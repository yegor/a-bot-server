module Messages
  module Geometry

    class Mesh

      include ::Phoenix::Messages::Base

      #  Fields defined on this message:
      #
      #  vertices: Messages::Geometry::Vertex( float x, float y, float z )[]
      #  triangles: Messages::Geometry::Triangle( int32 index0, int32 index1, int32 index2 )[]
      #


    end

  end
end
