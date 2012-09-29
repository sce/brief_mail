module BriefMail
  module SCMAdapters
    class AbstractAdapter

      # The diff stat for the current repository, as string.
      def diff_stat
        nil
      end

      # The log for the current repository, as string.
      def log
        nil
      end

      # The diff stat for any subdirectories not directly contained within
      # diff_stat for the current repository (e.g. git submodules) in the
      # format "{ "sub-directory-name" => "diff_stat" }".
      def subdirs_diff_stat
        {}
      end

      # The log for any subdirectories not directly contained whithin
      # log for the current repository (e.g. git submodules) in the format
      # "{ "sub-directory-name" => "log" }".
      def subdirs_log
        {}
      end

    end
  end
end
