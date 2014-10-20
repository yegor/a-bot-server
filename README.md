== Development setup
  1.  Install rvm
      $> \curl -sSL https://get.rvm.io | bash -s stable

  2.  Install rbx ruby
      $> rvm install rbx

  3.  Install google's protobuf
      $> brew install protobuf241
      $> brew link --force --overwrite protobuf241

  4.  Fetch all required gems
      $> bundle

  5.  Install zookeeper
      $> brew install zookeeper

  6.  Install 0mq
      $> brew install 0mq