class UserMailer < ActionMailer::Base
  default from: "noreply@rnrdb.pfitmap.org"
  Default_admin_email = "johannesalneberg@gmail.com"

  def evaluate_success_email(user,sequence_source)
    @user = user
    @sequence_source = sequence_source
    if user.email == Default_admin_email
      recipents = [user.email]
    else
      recipents = [user.email, Default_admin_email]
    end
    recipents.each  do |recipent|
      mail(to: recipent, :subject => "RNRdb successful evaluation")
    end
  end
  
  def evaluate_failure_email(user, sequence_source, error_message)
    @user = user
    @sequence_source = sequence_source
    @error_message = error_message
    if user.email == Default_admin_email
      recipents = [user.email]
    else
      recipents = [user.email, Default_admin_email]
    end
    recipents.each  do |recipent|
      mail(to: recipent, :subject => "RNRdb evaluation failure")
    end
  end

  def calculate_success_email(user, pfitmap_release)
    @user = user
    @pfitmap_release = pfitmap_release
    if user.email == Default_admin_email
      recipents = [user.email]
    else
      recipents = [user.email, Default_admin_email]
    end
    recipents.each do |recipent|
      mail(to: recipent, :subject => "RNRdb Calculation Success")
    end
  end
  
  def calculate_failure_email(user, pfitmap_release, error_message)
    @user = user
    @pfitmap_release = pfitmap_release
    @error_message = error_message
    if user.email == Default_admin_email
      recipents = [user.email]
    else
      recipents = [user.email, Default_admin_email]
    end
    recipents.each do |recipent|
      mail(to: recipent, :subject => "RNRdb Calculation Failure")
    end
  end
end
