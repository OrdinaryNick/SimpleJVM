module InterfacesReader
  def read_interfaces
    @class_file.interfaces_count = load_bytes(2).to_i(16)

    @class_file.interfaces_count.times do
      @class_file.interfaces << load_bytes(2).to_i(16)
    end
  end
end