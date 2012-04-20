class AppDrone::Template
  def initialize; @drones = {}; @directives = {} end

  def add(klass,*params)
    @drones[klass] = klass.new(self, params.first) # no idea why `.first` is required..
  end

  def drone_objects; @drones.values end
  def drone_classes; @drones.keys end
  def hook?(klass); @drones[klass].nil? end
  def hook(klass)
    raise "No such drone: #{klass}" unless i_klass = @drones[klass]
    return i_klass
  end
  
  def leftover_directives; @directives[:leftovers] || [] end
  def overridden_generator_methods; @directives.keys - [:leftovers] end

  def do!(d,drone);
    generator_method = drone.class.generator_method || :leftovers
    (@directives[generator_method] ||= []) << d
  end
  
  def check_dependencies
    puts drone_classes
    drone_classes.each { |drone_class|
      drone_class.dependencies.each { |d|
        dependency = d.to_s.classify
        raise "#{drone_class} depends on #{dependency}, but it is not included in the template." unless drone_classes.include?(d)
      }
    }
  end

  def render!
    return if @rendered
    check_dependencies
    drone_objects.map(&:align)
    drone_objects.map(&:execute)
    @rendered = true
  end

  def render_with_wrapper
    render!
    template_path = '/template.erb'
    full_path = File.dirname(__FILE__) + template_path
    snippet = ERB.new File.read(full_path)
    return snippet.result(binding)
  end

  def render_to_screen
    render!
    puts render_with_wrapper
  end

  def render_to_file
    render!
    File.open('out.rb','w+') do |f|
      f.write(render_with_wrapper)
    end
  end
  
end
