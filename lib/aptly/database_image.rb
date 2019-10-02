module Aptly
  class DatabaseImage < Resource
    def_attr :id
    def_attr :type
    def_attr :version
    def_attr :description
  end
end
