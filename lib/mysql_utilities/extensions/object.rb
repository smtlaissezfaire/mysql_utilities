module MysqlUtilities
  module Extensions
    module Object
      module ClassMethods

        # A call like the following: 
        #
        # lazy_attr_reader(:mysql_user)     { database["username"] }      
        #
        # Would add an instance method like the following:
        #
        # def mysql_user
        #   @mysql_user ||= database["username"]
        # end
        #      
        # The block given to lazy_attr_reader will be a default value.  
        # the block is given so that it evaluates at run time, and in
        # instance's context.
        #
        # If you don't care about that sort of thing, you can just
        # give it a second argument (but then it will evaluate on the class level)
        def lazy_attr_reader(instance_variable_name, default_value=nil, &default_block)
          raise ArgumentError, "lazy_attr_reader cannot take two default values" if default_block && default_value
          define_method(instance_variable_name) do
            value = instance_variable_get("@#{instance_variable_name}")
            value ||= default_block ? instance_eval(&default_block) : default_value
          end
        end
      end      
    end
  end
end

class Object  
  class << self
    include MysqlUtilities::Extensions::Object::ClassMethods
  end
end


