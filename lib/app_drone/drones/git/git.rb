# Incomplete
module AppDrone
class Git < Drone
  desc "Sets up a fresh git repo"
  def execute
    do! :install
  end
end
end
