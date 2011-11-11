alias set_trace_funk set_trace_func

def set_trace_func(*args)
  # DEBUGGER__::Context.send :attr_writer, :stop_next
  DEBUGGER__::Context.send :attr_writer, :finish_pos
  DEBUGGER__.context.send :finish_pos=, -1
  DEBUGGER__.context.stop_next -1
  set_trace_funk(*args)
end

SCRIPT_LINES__ = {} unless defined? SCRIPT_LINES__

# this is unbelievably stupid.
path = caller.first[/^[^:]+/]
SCRIPT_LINES__[path] = File.readlines(path)
SCRIPT_LINES__[__FILE__] = File.readlines(__FILE__)

require 'debug'

require "minitest/unit"

module MiniTest::Debugger
  def assert test, msg = nil
    begin
      super
    rescue MiniTest::Assertion => e
      warn "Assertion Failed. Dropping into debugger now:"
      DEBUGGER__.interrupt
      raise e
    end
  end
end

class MiniTest::Unit::TestCase
  include MiniTest::Debugger
end