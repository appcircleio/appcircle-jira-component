# frozen_string_literal: true

require 'English'
require 'net/http'
require 'json'

require 'dotenv'
Dotenv.load

def env_has_key(key)
  value = ENV[key]
  if !value.nil? && value != ''
    value.start_with?('$') ? ENV[value[1..]] : value
  else
    abort("Missing #{key}.")
  end
end

def is_integer?(str)
  /(\D+)/.match(str).nil?
end

def get_env(key)
  value = ENV[key]
  if !value.nil? && value != ''
    value.start_with?('$') ? ENV[value[1..]] : value
  end
end

def post(payload, endpoint, username, access_key, parse = true)
  uri = URI.parse(endpoint)
  req = Net::HTTP::Post.new(uri.request_uri,
                            { 'Content-Type' => 'application/json' })
  req.basic_auth(username, access_key)
  req.body = payload
  req.basic_auth(username, access_key)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  JSON.parse(res.body, symbolize_names: true) if parse
end

def get(endpoint, username, access_key)
  uri = URI.parse(endpoint)
  req = Net::HTTP::Get.new(uri.request_uri,
                           { 'Accept' => 'application/json' })
  req.basic_auth(username, access_key)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  JSON.parse(res.body, symbolize_names: true)
end

def create_payload(input, success)
  panel = success ? 'success' : 'error'
  input = input.sub('AC_JIRA_PANEL', panel)
  time = Time.now.utc.strftime('%m/%d/%Y %H:%M:%S')
  input = input.sub('AC_JIRA_DATE', time)

  payload = {
    body: JSON.parse(input)
  }
  payload.to_json
end

def transitionid(id, transitions)
  if is_integer?(id)
    success_id
  else
    transitions[:transitions].find { |t| t[:name].casecmp(id).zero? }[:id]
  end
end

jira_host = env_has_key('AC_JIRA_HOST')
username = env_has_key('AC_JIRA_EMAIL')
access_key = env_has_key('AC_JIRA_TOKEN')
issue_id = env_has_key('AC_JIRA_ISSUE')
is_success = get_env('AC_IS_SUCCESS')
puts "is_success #{is_success}"
success = is_success == 'true' || is_success == 'True'
success_id = get_env('AC_JIRA_SUCCESS_TRANSITION')
failure_id = get_env('AC_JIRA_FAIL_TRANSITION')
input = env_has_key('AC_JIRA_TEMPLATE')
puts "Input #{input}"
endpoint = "#{jira_host}/rest/api/3/issue/#{issue_id}/comment"
payload = create_payload(input, success)
puts "Payload #{payload}"
puts "Posting comment for #{issue_id}"
$stdout.flush
result = post(payload, endpoint, username, access_key)
puts "Result #{result}"
puts "Comment #{result[:id]} posted"
$stdout.flush

if success_id || failure_id
  endpoint = "#{jira_host}/rest/api/3/issue/#{issue_id}/transitions"
  result = get(endpoint, username, access_key)
  if success
    id = transitionid(success_id, result)
    puts 'Workflow succeeded'
  else
    id = transitionid(failure_id, result)
    puts 'Workflow failed.'
  end
  puts "Transition ID: #{id}"
  $stdout.flush

  endpoint = "#{jira_host}/rest/api/3/issue/#{issue_id}/transitions"
  payload = "{\"transition\":{\"id\":\"#{id}\"}}"
  post(payload, endpoint, username, access_key, false)
  puts "Issue transitioned to #{id}"
end
