newparam(:queue_name) do
  include EasyType
  include EasyType::Validators::Name

  isnamevar

  desc 'The queue name'

end
