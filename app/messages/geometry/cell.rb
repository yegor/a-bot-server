module Messages
  module Geometry

    class Cell

      include ::Phoenix::Messages::Base

      #  Fields defined on this message:
      #
      #  mesh: Messages::Geometry::Mesh( Messages::Geometry::Vertex( float x, float y, float z )[] vertices, Messages::Geometry::Triangle( int32 index0, int32 index1, int32 index2 )[] triangles )
      #


    end

  end
end
