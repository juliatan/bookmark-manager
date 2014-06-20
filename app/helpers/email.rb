API_KEY = ENV['MAILGUN_API_KEY']

def send_recovery_email(email, url)

  uri = "https://api:#{API_KEY}@api.mailgun.net/v2/app26585045.mailgun.org/messages"

  RestClient.post uri,
  :from => "Excited User <me@app26585045.mailgun.org>",
  :to => email,
  :subject => "Not a password reset!",
  :text => url
end