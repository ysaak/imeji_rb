class Parameter < ActiveRecord::Base

  def self.import_path
    import_path = (self.find_by_name 'import_path').value
    if not import_path.end_with? '/'
      import_path += '/'
    end
    import_path
  end
end
