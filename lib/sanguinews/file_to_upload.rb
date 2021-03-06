########################################################################
# FileToUpload - File class' extension specifically for sanguinews
# Copyright (c) 2013, Tadeus Dobrovolskij
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this library; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
########################################################################

module Sanguinews
  class FileToUpload < File
    attr_accessor :name, :chunks, :subject, :messages
    attr_reader :crc32, :nzb, :dir_prefix, :cname

    def initialize(var)
      @dir_prefix = ''

      var[:mode] = "rb" if var[:mode].nil?

      super(var[:name], var[:mode])
      @filemode = var[:filemode]
      @name = File.basename(var[:name])
      chunk_amount(var[:chunk_length])
      common_name(var)
      @from = var[:from]
      @groups = var[:groups]
      if var[:nzb]
        nzb_init
      end
      @messages = []
      @chunks.times do |x|
	subject = "#{var[:prefix]}#{@dir_prefix}\"#{@name}\" yEnc (#{x+1}/#{@chunks})"
	@messages[x] = NntpMsg.new(@from, @groups, subject)
	@messages[x].xna = var[:xna]
      end
      return @name
    end

    def close(last=false)
      if @nzb
        @nzb.write_file_header(@from, @subject, @groups)
        @nzb.write_segments
        @nzb.write_file_footer
        @nzb.write_footer if @filemode || last
      end
      super()
    end

    def write_segment_info(length, chunk, msgid)
      @nzb.save_segment(length, chunk, msgid) if @nzb
    end

    def file_crc32
      fcrc32 = false
      @messages.each do |message|
	fcrc32 &&= Zlib.crc32_combine(fcrc32, message.part_crc32.to_i(16), message.length)
	fcrc32 ||= message.part_crc32.to_i(16)
      end
      @crc32 = fcrc32.to_s(16)
    end

    private

    def chunk_amount(chunk_length)
      chunks = self.size.to_f / chunk_length
      @chunks = chunks.ceil
    end

    def common_name(var)
      if var[:filemode]
        @cname = File.basename(var[:name])
      else
        @cname = File.basename(File.dirname(var[:name]))
        @dir_prefix = @cname + " [#{var[:current]}/#{var[:last]}] - "
      end
        @subject = "#{var[:prefix]}#{@dir_prefix}#{@name} yEnc (1/#{@chunks})"
    end

    def nzb_init
      @nzb = Nzb.new(@cname, "sanguinews_")
      @nzb.write_header
    end

  end
end
