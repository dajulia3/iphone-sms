class Contact
  #NOTE: calculation methods won't work, but we don't care!
  def self.method_missing(sym, *args, &block)
    if sym == :update_all
      raise NoMethodError.new("Contact doesn't allow update all - it is a composite model", sym)
    end
    if pass_sym_to_person_class?
        return ABPerson.send :sym, *args, &block
    elsif pass_sym_to_multi_class?
      return ABMultiValue.send :sym, *args, &block
    else
      super sym, *args, &block
    end
  end


  def self.pass_sym_to_person_class?(sym, *args, &block)
    if Person.respond_to? sym
      temp_result = Person.send sym, *args, &block
      if temp_result.is_a? ABPerson || temp_result == [] || temp_result.is_a?(Array) && temp_result[0].is_a?(ABPerson)
        true
      end
    else
      false
    end
  end

  def self.pass_sym_to_multi_class?(sym, *args, &block)
    if Person.respond_to? sym
      temp_result = Person.send sym, *args, &block
      if temp_result.is_a? ABPerson || temp_result == [] || temp_result.is_a?(Array) && temp_result[0].is_a?(ABPerson)
        true
      end
    else
      false
    end
  end

  def self.respond_to?
    pass_sym_to_person_class?
    pass_sym_to_multi_class
  end

  def method_missing
    #TODO FIXME
    if basdfadf
    else
      super
    end
  end

  def respond_to?
  end
  #def initialize(attrs_hash)
  #  @person = ABPerson
  end
  class ABPerson < ContactsRecordBase
    self.primary_key = 'ROWID'
    self.table_name = 'ABPerson'

    def full_name
      First + Last
    end
  end

  class ABMultiValue

  end



end