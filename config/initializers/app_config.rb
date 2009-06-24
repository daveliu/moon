PROJECT_NAME = "Inter"

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%Y-%m-%d %H:%M",
  :date => "%Y-%m-%d",
  :time => "%I:%M %p"
)

I18n.default_locale = 'zh-CN'
I18n.locale         = 'zh-CN'