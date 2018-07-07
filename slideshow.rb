require 'watir'
require 'webdrivers'
require 'yaml'

browser = Watir::Browser.new :chrome
browser.driver.manage.window.maximize

playlist = YAML.load_file('playlist.yml')

if playlist.length == 0
    puts 'The playlist is empty.'
    exit
end

begin
    index = 0
    loop do
        item = playlist[index]

        case item['type']
        when 'image-gallery'
            total_duration = 0
            max_duration = item['max-duration'] || 60

            duration_per_image = item['duration'] || 10

            item['images'] ||= []

            while total_duration < max_duration

                # Load the images if we are out of images.
                if item['images'].empty?
                    entries = Dir.entries(item['path'])
                    # Remove the current and parent directory.
                    files = entries.select { |f| f != '.' and f != '..' }
                    item['images'] = files.shuffle
                end

                if !item['images'].empty?
                    image_url = "file://#{item['path']}#{item['images'].pop}"
                    browser.goto image_url
                    sleep duration_per_image
                end

                total_duration += duration_per_image
            end

        when 'website'
            browser.goto item['url']
            sleep(item['duration'] || 10)

            # Run each sub-item, if any.
            (item['then-click'] || []).each do |sub_item|
                browser.a(:css => sub_item['selector']).click
                sleep(sub_item['duration'] || 10)
            end
        end

        index += 1
        index = 0 if index >= playlist.length
    end
rescue => e
    puts 'An error occurred.'
    puts e
    puts e.backtrace
end
