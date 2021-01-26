Ransack.configure do |config|
  config.add_predicate :during_year,
                       arel_predicate: :between,
                       formatter: proc { |v|
                         Time.zone.parse("#{v.year}-1-1").to_date...Time.zone.parse("#{v.year + 1}-1-01").to_date
                       },
                       type: :date
end