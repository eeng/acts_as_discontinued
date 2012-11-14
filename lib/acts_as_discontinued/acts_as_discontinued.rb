module ActsAsDiscontinued
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods    
    def acts_as_discontinued(options = {})
      include InstanceMethods
      class_eval do
        scope :active, :conditions => {:discontinued_at => nil}
        scope :status, lambda { |*args|
          stat = args.first.to_s
          case stat
          when 'active', ''
            {:conditions => {:discontinued_at => nil}}
          when 'inactive'
            {:conditions => "#{table_name}.discontinued_at is not null"}
          else
            {}
          end 
        }
      end
    end
  end
  
  module InstanceMethods 
    def discontinue!
      self.update_attribute :discontinued_at, Time.now
      self
    end
    
    def activate!
      self.update_attribute :discontinued_at, nil
      self
    end
    
    def discontinued? date = Time.now
      not discontinued_at.nil? and discontinued_at <= date
    end
    alias inactive? discontinued?
    
    def active? date = Time.now
      not discontinued? date
    end
    alias active active?
    
    def active= active
      if ['true', '1'].include?(active.to_s)
        self.discontinued_at = nil
      else
        self.discontinued_at ||= Time.now
      end
    end
    
    def activation_status
      active? ? 'Activo' : 'Inactivo'
    end
  end
end
