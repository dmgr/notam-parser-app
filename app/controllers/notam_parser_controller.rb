require 'dmg/notam/record'

class NotamParserController < ApplicationController
  def input
  end

  def results
    @notam_records = []
    raw_record = ""
    io = params[:notam_records].open

    io.each_line do |line|
      if line.blank?
        maybe_collect_aerodrome_service_record raw_record
        raw_record = ""
      else
        raw_record << line << " "
      end
    end

    io.close
    maybe_collect_aerodrome_service_record raw_record
  end

  private

  def maybe_collect_aerodrome_service_record raw_record
    if raw_record['AERODROME HOURS OF OPS/SERVICE']
      @notam_records << Dmg::Notam::Record.new(raw_record)
    end
  end
end
