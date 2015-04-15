require 'json'
require 'httparty'

# I run this script to get all the data, then go back and delete the extra message headers.
# Once it's done, open the file, search for "new_message_page", & clean up the end of the last block
# and the beginning of the new ones to get a clean JSON with all messages in one place.

file_name = 'messagesV2' #'what you want the filename to be'
messages_file = Dir.pwd + '/' + file_name + '.json'

token = #'put your token here'

channel = #'your channel aka group number. Get it from groups.list'

# Regex for timestamps /"[0-9\.]+"/
# Christoph's regex string 
# /$  \],$  "has_more": true$\}$new_message_page\{$  "ok": true,$  "latest": "[0-9\.]+",$  "messages": \[/m
# save to regex = /$  \],$  "has_more": true$\}$new_message_page\{$  "ok": true,$  "latest": "[0-9\.]+",$  "messages": \[/m
# regex.class
# regex.match content --- content is the buffer that contains my_file.read

response = HTTParty.get('https://slack.com/api/groups.history?token=' + token + '&channel=' + channel + '&count=1000&pretty=1')

while (response["has_more"] == true) do
  my_file = File.open(messages_file, 'a') do |f|
      f << JSON.pretty_generate(response)
      f << "\n"
      f << "new_message_page"
    end
  ts = response["messages"].last["ts"]
  response = HTTParty.get('https://slack.com/api/groups.history?token=' + token + '&channel=' + channel + '&latest=' + ts + '&count=1000&pretty=1')
end

if (response["has_more"] == false) 

    ts = response["messages"].last["ts"]
    my_file = File.open(messages_file, 'a') do |f|
     f << JSON.pretty_generate(response)
     f << "\n"
    end

end


puts "All done"





