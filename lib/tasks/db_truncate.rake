namespace :db do
  desc "Truncate all existing data"
  task :truncate => "db:load_config" do
   begin
    config = ActiveRecord::Base.configurations[::Rails.env]
    ActiveRecord::Base.establish_connection
    case config["adapter"]
      when "mysql"
        interesting_tables.each do |table|
          ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        end
      when"postgresql"
        interesting_tables.each do |table|
          ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE")
        end
      when "sqlite", "sqlite3"
        interesting_tables.each do |table|
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
          ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence where name='#{table}'")
        end                                                                                                                               
       ActiveRecord::Base.connection.execute("VACUUM")
     end
    end
  end

  def interesting_tables
    ActiveRecord::Base.connection.tables.sort.reject do |tbl|
      ['schema_migrations', 'sessions', 'public_exceptions'].include?(tbl)
    end
  end
end
