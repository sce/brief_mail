require 'forwardable'

module BriefMail
  module SCMAdapters
    class Git < AbstractAdapter

      # Compact git format to use for log commands:
      GIT_FORMAT = %(* %ad %s%+b).freeze

      def initialize(config)
        @config = config
      end

      def diff_stat
        if previous_revision
          cmd = %(git diff %s.. --stat --color=never) % previous_revision
          %x(#{cmd})
        else
          ""
        end
      end

      def log
        if previous_revision
          cmd = %(git log %s.. --pretty='%s' --date=short --reverse --color=never) %
            [previous_revision, format]

          %x(#{cmd})
        else
          ""
        end
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

      private

      attr_reader :config

      extend Forwardable
      def_delegators :config,
          :current_revision,
          :from_user,
          :previous_revision

      def format
        from_user[:git_format] || GIT_FORMAT
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
        if previous_revision and current_revision
          submodule_dirs.inject({}) do |h, subm|
            subm_prev = submodule_sha_at(subm, previous_revision)
            subm_cur = submodule_sha_at(subm, current_revision)

            Dir.chdir(subm) do
              output = yield(subm_prev, subm_cur)
              if output.strip =~ /.+/
                h[subm] = output
              end
            end

            h
          end
        else
          Hash.new
        end
      end

    end
  end
end
