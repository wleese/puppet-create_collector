Puppet::Parser::Functions::newfunction(:create_collector, :doc => <<-'ENDHEREDOC') do |args|
    Creates a collector and applies overrides

    First argument is the resource type, second the parameter/property you want to match, third its
    value and finally a hash of parameters/properties you want to override.
   
    $overrides = { "uid" => "8888","groups" => ["wheel","audio"] }
    create_collector('user', 'title', 'myusers', $overrides)
  ENDHEREDOC

  raise ArgumentError, ("create_collector(): wrong number of arguments (#{args.length}; must be 3 or 4)") unless (3..4).include?(args.length)

  type_name = args[0].downcase
  match_attrib = args[1]
  match_value  = args[2]
  form = :virtual #not :exported

  if match_attrib == "title"
    vquery = proc { |res| res.title == match_value }
  else
    vquery = proc { |res| 
      if res[match_attrib].is_a?(Array)
        res[match_attrib].include?(match_value) 
      else
        res[args[1]] == match_value 
      end
    }
  end

  collector = Puppet::Parser::Collector.new(self, type_name, nil, vquery, form)

  if args[3]
    overrides = args[3]
    raise ArgumentError, ("create_collector(): overrides should be a Hash") unless overrides.is_a?(Hash)

    overrided_params = overrides.collect { |name, value| Puppet::Parser::Resource::Param.new( :name => name, :value => value, :source => self) }
    collector.add_override(:parameters => overrided_params, :source => self, :scope => self)
  end

  compiler.add_collection(collector)
end
