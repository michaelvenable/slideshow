require 'watir'
require 'yaml'

browser = Watir::Browser.new :firefox
browser.driver.manage.window.maximize

playlist = YAML.load_file('playlist.yml')

if playlist.length == 0
    puts 'The playlist is empty.'
    exit
end

index = 0
loop do
    item = playlist[index]

    case item['type']
    when 'website'
        browser.goto item['url']
        sleep(item['duration'] || 10)

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
    end

    index += 1
    index = 0 if index >= playlist.length
end

