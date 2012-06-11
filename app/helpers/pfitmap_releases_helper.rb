module PfitmapReleasesHelper
  def get_head_release
    return PfitmapRelease.find_by_current(true)
  end
    

  class CurrentReleaseValidator < ActiveModel::Validator
    def validate(record)
      current_release = get_head_release
      if current_release
        if record.current
            record.errors[:base] << "There can only be one current release!"
        end
      end
    end
  end
end
