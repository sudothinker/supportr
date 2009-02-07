RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

God.watch do |w|
  # script that needs to be run to start, stop and restart
  script          = "ruby #{RAILS_ROOT}/script/mail_fetcher" 
  # attaching rails env to each script line to be sure the daemon starts in production mode
  rails_env       = "RAILS_ENV=production" 

  w.name          = "mail-fetcher" 
  w.group         = "mail" 
  w.interval      = 60.seconds
  w.start         = "#{rails_env} #{script} start" 
  w.restart       = "#{rails_env} #{script} restart" 
  w.stop          = "#{rails_env} #{script} stop" 
  w.start_grace   = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file      = "#{RAILS_ROOT}/log/MailFetcherDaemon.pid" 

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 45.megabytes
      c.times = [3, 5]
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end