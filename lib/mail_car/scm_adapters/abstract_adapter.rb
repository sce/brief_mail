module MailCar
  module SCMAdapters
    class AbstractAdapter

      # The diff stat for the current repository, as string.
      def diff_stat
        nil
      end

      # The shortlog for the current repository, as string.
      def shortlog
        nil
      end

      # The diff stat for any subdirectories not directly contained within
      # diff_stat for the current repository (e.g. git submodules) in the
      # format "{ "sub-directory-name" => "diff_stat" }".
      def subdirs_diff_stat
        {}
      end

      # The shortlog for any subdirectories not directly contained whithin
      # shortlog for the current repository (e.g. git submodules) in the format
      # "{ "sub-directory-name" => "shortlog" }".
      def subdirs_shortlog
        {}
      end

    end
  end
end
