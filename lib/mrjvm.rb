require 'mrjvm/version'
require 'mrjvm/class_file/java_class'
require 'mrjvm/heap/class_heap'
require 'mrjvm/heap/object_heap'
require 'mrjvm/heap/frame'
require 'mrjvm/execution_core'

module MRjvm
  DEBUG_STRING = '[DEBUG] '

  def self::debug(string)
    puts DEBUG_STRING + string + "\n" if DEBUG
  end

  class MRjvm
    def self::print_file(file)
      reader = ClassFileReader.new(file)
      reader.parse_content
      puts reader.class_file
    end

    # File is not used, because of testing
    def self::run(file)
      class_heap = Heap::ClassHeap.new
      java_class = class_heap.load_class('Test')
      #java_class_object = class_heap.load_class('java/lang/Object')

      object_heap = Heap::ObjectHeap.new

      frame_stack = Array.new(20, Heap::Frame.new)
      start_frame = 0
      Heap::Frame.base_frame = frame_stack[start_frame]
      Heap::Frame.op_stack = Array.new(100, nil) # Variable, 100

      executing_core = ExecutionCore.new
      executing_core.class_heap = class_heap
      executing_core.object_heap = object_heap

      object_id = object_heap.create_object(java_class)
      method_index = java_class.get_method_index('hello') # Here must be name of method, which will be started.
      frame_stack[start_frame].frame_class = java_class
      frame_stack[start_frame].method = java_class.methods[method_index]
      frame_stack[start_frame].stack = Heap::Frame.op_stack
      frame_stack[start_frame].sp = 0#frame_stack[start_frame].method[:attributes]#[:max_locals] # TODO Edit? Where to find?
      frame_stack[start_frame].stack[0] = object_id
      executing_core.execute(frame_stack)
    end
  end
end