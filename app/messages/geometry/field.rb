module Messages
  module Geometry

    class Field

      include ::Phoenix::Messages::Base

      #  Fields defined on this message:
      #
      #  cells: Messages::Geometry::Cell( Messages::Geometry::Mesh( Messages::Geometry::Vertex( float x, float y, float z )[] vertices, Messages::Geometry::Triangle( int32 index0, int32 index1, int32 index2 )[] triangles ) mesh )[]
      #

    end

  end
end
