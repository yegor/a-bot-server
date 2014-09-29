::Celluloid::AbstractProxy.class_eval do
  define_method( :frozen? ) { false }
  define_method( :taint )   { self }
end