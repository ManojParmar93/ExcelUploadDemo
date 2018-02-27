require 'roo'

class NotSupportedFile < StandardError; end;

class User < ApplicationRecord
  SUPPORTED_FORMATES = %w(.csv .xls .xlsx)
  COLUMNS = %w(id first_name last_name email password)

  validates :first_name, :last_name, :email, :password, presence: true
  validates_uniqueness_of :email
  validates :email, format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}

  def self.create_from_file(files)
    files.each do |file|
      excel_file = open_spreadsheet(file)
      headers = excel_file.row(1).collect(&:downcase)
      (2..excel_file.last_row).each do |row|
        create(prepare_data(headers, excel_file, row))
      end
    end
  end

  def self.prepare_data(headers, excel_file, row)
    data_from_file = headers.zip(excel_file.row(row)).to_h
    data_from_file.select{|header, value| p COLUMNS.include?(header)}
  end

  def self.open_spreadsheet(file)
    Roo::Spreadsheet.open(file.tempfile, extension: :xlsx)
  end

  def self.reject_if_unknown_file(files)
    raise NotSupportedFile.new('Some Of The Files Not Supported.') if unknow_formates_present?(files)
  end

  def self.unknow_formates_present?(files)
    files.select{|file| SUPPORTED_FORMATES.exclude?(File.extname(file.original_filename))}.present?
  end
end
