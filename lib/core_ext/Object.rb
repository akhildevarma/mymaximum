class Object
  def as(&block)
    # run on given object and return result of block
    instance_eval(&block)
  end
end
