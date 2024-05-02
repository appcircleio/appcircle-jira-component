# frozen_string_literal: true

require 'English'
require 'net/http'
require 'json'
require 'base64'

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

def jira_auth(jira_token, username = nil)
  if $jira_pat != nil
    return "Bearer #{jira_token}"
  else
    if username == nil
      abort("Missing Jira e-mail. If you will not use Personal Access Token as authorization, you must enter your Jira e-mail and API token.")
    end
    return "Basic #{Base64.strict_encode64("#{username}:#{jira_token}")}"
  end
end

def handle_http_errors(response)
  case response
  when Net::HTTPClientError, Net::HTTPServerError
    abort "\nError: #{response.code} #{response.message}\n#{response.body}\n\n"
  end
end

def post(payload, endpoint, jira_token, username = nil, parse = true)
  uri = URI.parse(endpoint)
  req = Net::HTTP::Post.new(uri.request_uri,
                            { 'Content-Type' => 'application/json' })
  req['Authorization'] = jira_auth(jira_token, username)
  req.body = payload
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  handle_http_errors(res)
  JSON.parse(res.body, symbolize_names: true) if parse
end

def get(endpoint, jira_token, username = nil)
  uri = URI.parse(endpoint)
  req = Net::HTTP::Get.new(uri.request_uri,
                           { 'Accept' => 'application/json' })
  req['Authorization'] = jira_auth(jira_token, username)
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  handle_http_errors(res)
  JSON.parse(res.body, symbolize_names: true)
end

def create_payload(input, success)
  panel = success ? 'success' : 'error'
  input = input.sub('AC_JIRA_PANEL', panel)
  time = Time.now.utc.strftime('%m/%d/%Y %H:%M:%S')
  input = input.sub('AC_JIRA_DATE', time)

  if $rest_api_version != 2
    input = JSON.parse(input)
  end

  payload = {
    body: input
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
username = get_env('AC_JIRA_EMAIL')
access_key = get_env('AC_JIRA_TOKEN')
$jira_pat = get_env('AC_JIRA_PAT')
jira_token = $jira_pat || access_key
if jira_token.nil?
  abort "Could not find Jira token or PAT for authentication."
end
issue_id = env_has_key('AC_JIRA_ISSUE')
is_success = get_env('AC_IS_SUCCESS')
success = is_success == 'true' || is_success == 'True'
success_id = get_env('AC_JIRA_SUCCESS_TRANSITION')
failure_id = get_env('AC_JIRA_FAIL_TRANSITION')
input = env_has_key('AC_JIRA_TEMPLATE')
$rest_api_version = env_has_key('AC_JIRA_REST_API_VERSION').to_i
endpoint = "#{jira_host}/rest/api/#{$rest_api_version}/issue/#{issue_id}"
comment_endpoint = endpoint + "/comment"
payload = create_payload(input, success)
puts "Posting comment for #{issue_id}"
$stdout.flush
result = post(payload, comment_endpoint, jira_token, username, true)
puts "Comment #{result[:id]} posted"
$stdout.flush

if success_id || failure_id
  transitions_endpoint = endpoint + "/transitions"
  result = get(transitions_endpoint, jira_token, username)
  if success
    id = transitionid(success_id, result)
    puts 'Workflow succeeded'
  else
    id = transitionid(failure_id, result)
    puts 'Workflow failed.'
  end
  puts "Transition ID: #{id}"
  $stdout.flush

  payload = "{\"transition\":{\"id\":\"#{id}\"}}"
  post(payload, transitions_endpoint, jira_token, username, false)
  puts "Issue transitioned to #{id}"
end