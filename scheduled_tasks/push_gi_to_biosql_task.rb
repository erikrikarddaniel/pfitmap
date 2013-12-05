class PushGiToBiosqlTask < Scheduler::SchedulerTask
  environments :all
  # environments :staging, :production
  
  # every '30m'
  self.in '30s'
  # other examples:
  # every '24h', :first_at => Chronic.parse('next midnight')
  # cron '* 4 * * *'  # cron style
  # in '30s'          # run once, 30 seconds from scheduler start/restart
  
  
  def run
    # Your code here, eg: 
    # User.send_due_invoices!
    DbEntry.gis2gi_queue
    # use log() for writing to scheduler daemon log
    log("sent gis to gi queue")
  end
end
