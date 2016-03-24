require 'webrick'
require 'socket'
require 'timeout'
require 'uri'
require 'erb'
require 'json'
require 'pry'
require_relative '../config/router'
require_relative '../app/controllers/application_controller'
require_relative '../lib/all'

module App
  def App.posts
    @all_posts ||= [
      (Post.new(1, "First day of class", "Colin Recko", "Today was the first day of class. It went really well. I love learning!", true)),
      (Post.new(2, "Second day of class", "Colin Recko", "Today was the second day of class. It was really fun. I like coding.", true)),
      (Post.new(3, "Third day of class", "Colin Recko", "Today is the third day of class. It was really hard. I need to study more.", true)),
      (Post.new(4, "Fourth day of class", "Colin Recko", "Today is the fourth day of class. It was much better. I am glad I am here.", true)),
      (Post.new(5, "Fifth day of class", "Colin Recko", "Today is the fifth day of class. Ruby is the best coding language ever", true))
    ]
  end
  def App.comments
    @all_pcomments ||= [
      (Comment.new(1, "I'm glad you enjoyed it!", "Sarah Huey", 1)),
      (Comment.new(2, "Keep studying!", "Elizer Rios", 2)),
      (Comment.new(3, "Don't give up!", "Steven Ralph", 3)),
      (Comment.new(4, "I'm sure you're doing great!", "Maura Recko", 4)),
      (Comment.new(5, "Ruby sucks!", "Whitney Farrior", 5))
    ]
  end
end

system('clear')

def start_custom_webbrick_server
  server = WEBrick::HTTPServer.new(Port: 3001)
  server.mount "/", WEBBrickServer

  trap(:INT)  { server.shutdown }
  trap(:TERM) { server.shutdown }

  puts "The server is running and awaiting requests at http://localhost:3001/"
  server.start
end

def start_custom_tcp_server
  CustomTCPServer.new.start
end


if ARGV[0] == '--no-webrick'
  start_custom_tcp_server
else
  start_custom_webbrick_server
end
