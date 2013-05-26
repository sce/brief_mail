require 'brief_mail/error'

module BriefMail
  module SCMAdapters
    class Git < AbstractAdapter
      Error = Class.new BriefMail::Error

      class MissingDataError < Error
        def initialize(args)
          config, field = *args
          super %(Missing "%s" from config: %s) % [field, config.inspect]
        end
      end

      # Compact git format to use for log commands:
      GIT_FORMAT = %(* %ad %s%+b).freeze

      private

      def initialize(config)
        @config = config
      end

      def format
        @config.from_user[:git_format] || GIT_FORMAT
      end

      # Returns array with name of submodule directories.
      def submodule_dirs
        # Implementation is a little hacky; we run a git command and parse the
        # output.
        cmd = %(git submodule)
        %x(#{cmd}).split(/\n/).map {|line| line.split(" ")[1] }
      end

      # Returns the SHA-1 given submodule is at in given root repository SHA-1.
      def submodule_sha_at(submodule_name, root_sha)
        # Finding the SHA-1 that each submodule uses for a given commit is a
        # little hacky; we run a git command and parse the output.
        cmd = %(git ls-tree %s %s) % [root_sha, submodule_name]
        %x(#{cmd}).split(" ")[2]
      end

      # Yield for each submodule previous_revision and current_revision for
      # that submodule, and return as { "dir-name" => "yield output" } hash.
      def submodule_command
        fail MissingDataError, [@config, :previous_revision] unless @config.previous_revision
        fail MissingDataError, [@config, :current_revision] unless @config.current_revision

        submodule_dirs.inject({}) do |h, subm|
          subm_prev = submodule_sha_at(subm, @config.previous_revision)
          subm_cur = submodule_sha_at(subm, @config.current_revision)

          Dir.chdir(subm) do
            output = yield(subm_prev, subm_cur)
            if output.strip =~ /.+/
              h[subm] = output
            end
          end

          h
        end
      end

      public

      def diff_stat
        fail MissingDataError, [@config, :previous_revision] unless @config.previous_revision
        cmd = %(git diff %s.. --stat --color=never) % @config.previous_revision
        %x(#{cmd})
      end

      def log
        fail MissingDataError, [@config, :previous_revision] unless @config.previous_revision
        cmd = %(git log %s.. --pretty='%s' --date=short --reverse --color=never) %
          [@config.previous_revision, format]

        %x(#{cmd})
      end

      def subdirs_log
        submodule_command do |prev_sha, cur_sha|
          cmd = %(git log %s..%s --pretty='%s' --date=short --reverse --color=never) %
            [prev_sha, cur_sha, format]

          %x(#{cmd})
        end
      end

      def subdirs_diff_stat
        submodule_command do |prev_sha, cur_sha|
          cmd = %(git diff %s..%s --stat --color=never) %
            [prev_sha, cur_sha]

          %x(#{cmd})
        end
      end

    end
  end
end
