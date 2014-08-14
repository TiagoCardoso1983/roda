class Roda
  module RodaPlugins
    # The all_verbs plugin adds methods for http verbs other than
    # get and post.  The following verbs are added, assuming
    # rack handles them: delete, head, options, link, patch, put,
    # trace, unlink.
    #
    # These methods operate just like Roda's default get and post
    # methods other that the http verb used, so using them without
    # any arguments just checks for the request method, while
    # using them with any arguments also checks that the arguments
    # match the full path.
    #
    # Example:
    #
    #   plugin :all_verbs
    #
    #   route do |r|
    #     r.delete
    #       # Handle DELETE
    #     end
    #     r.put do
    #       # Handle PUT
    #     end
    #     r.patch do
    #       # Handle PATCH
    #     end
    #   end
    #
    # The verb methods are defined via metaprogramming, so there
    # isn't documentation for the individual methods created.
    module AllVerbs
      def self.configure(app)
        %w'delete head options link patch put trace unlink'.each do |v|
          if ::Rack::Request.method_defined?("#{v}?")
            app.request_module do
              app::RodaRequest.def_verb_method(self, v)
            end
          end
        end
      end
    end

    register_plugin(:all_verbs, AllVerbs)
  end
end
