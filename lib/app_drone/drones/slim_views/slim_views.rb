module AppDrone
class SlimViews < Drone
  # TODO accepts :options # header etc.

  def align
    (self >> Gems).add 'slim-rails'
  end

  def execute
    do! :application_slim
  end
end
end