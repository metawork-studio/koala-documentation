Jekyll::Hooks.register :site, :after_reset do |site|
  root_directory = Dir.pwd
  source_directory = '_documentation'
  destination_directory_mobile = '_mobile'
  destination_directory_tablet = '_tablet'

  files_to_duplicate = Dir.glob("#{source_directory}/**/*.*", base: root_directory)

  files_to_duplicate.each do |file|
    relative_path = file.sub(/^#{source_directory}\//, '')
    mobile_path = File.join(root_directory, destination_directory_mobile, relative_path)
    tablet_path = File.join(root_directory, destination_directory_tablet, relative_path)

    if File.file?(file)
      FileUtils.mkdir_p(File.dirname(mobile_path))
      FileUtils.mkdir_p(File.dirname(tablet_path))
      FileUtils.cp(file, mobile_path)
      FileUtils.cp(file, tablet_path)

      # Add the duplicated files to the exclude list
      site.config['exclude'] << mobile_path
      site.config['exclude'] << tablet_path
    else
      FileUtils.mkdir_p(mobile_path)
      FileUtils.mkdir_p(tablet_path)
    end
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  root_directory = site.source
  mobile_dir = File.join(root_directory, '_mobile')
  tablet_dir = File.join(root_directory, '_tablet')
  mobile_template_parts_dir = File.join(site.dest, 'mobile', 'chapters')
  tablet_template_parts_dir = File.join(site.dest, 'tablet', 'chapters')

  FileUtils.rm_rf(mobile_dir) if Dir.exist?(mobile_dir)
  FileUtils.rm_rf(tablet_dir) if Dir.exist?(tablet_dir)
  FileUtils.rm_rf(mobile_template_parts_dir) if Dir.exist?(mobile_template_parts_dir)
  FileUtils.rm_rf(tablet_template_parts_dir) if Dir.exist?(tablet_template_parts_dir)
end
