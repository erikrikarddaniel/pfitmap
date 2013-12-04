class PushGisToBiosqlTask < Scheduler::SchedulerTask
  environments :production, :development
  # environments :staging, :production
  
  self.in '30s' 
  # other examples:
  # every '24h', :first_at => Chronic.parse('next midnight')
  # cron '* 4 * * *'  # cron style
  # in '30s'          # run once, 30 seconds from scheduler start/restart
  
  
  def run
    # Your code here, eg: 
    # User.send_due_invoices!
    gis = DbEntry.find(:all,select: "gi", include: [:db_sequence], conditions: ["db_sequences.sequence IS NULL"]).map {|e| e.gi.to_s}


    result = BiosqlWeb.gis2queue(gis)


    # use log() for writing to scheduler daemon log
    log("Sent #{gis.length} gi's to be added to queue")
  end
end
