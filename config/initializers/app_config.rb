PROJECT_NAME = "Inter"

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%Y-%m-%d %H:%M",
  :date => "%Y-%m-%d",
  :time => "%I:%M %p"
)

I18n.default_locale = 'zh-CN'
I18n.locale         = 'zh-CN'


ActionMailer::Base.smtp_settings = {
   :tls => true,
   :address => "smtp.gmail.com",
   :port => "587",
   :domain => "beibeigan",
   :authentication => :plain,
   :user_name => "dave.liu@beibeigan.com",
   :password => "dave.liu" 
}        
SITE_MAIL="dave.liu@beibeigan.com"


SITE_DOMAIN = "58.30.227.14:3001" 