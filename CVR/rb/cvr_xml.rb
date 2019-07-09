require 'roxml'


module CVRV1
end

classes = [CVRV1::CVR::Annotation, CVRV1::CVR::CVR, CVRV1::CVR::CVRContest, CVRV1::CVR::CVRContestSelection, CVRV1::CVR::CVRSnapshot, CVRV1::CVR::CVRWriteIn, CVRV1::CVR::Candidate, CVRV1::CVR::CastVoteRecordReport, CVRV1::CVR::Code, CVRV1::CVR::Contest, CVRV1::CVR::ContestSelection, CVRV1::CVR::Election, CVRV1::CVR::File, CVRV1::CVR::GpUnit, CVRV1::CVR::Hash, CVRV1::CVR::Image, CVRV1::CVR::ImageData, CVRV1::CVR::Party, CVRV1::CVR::PartyContest, CVRV1::CVR::PartySelection, CVRV1::CVR::ReportingDevice, CVRV1::CVR::SelectionPosition, CVRV1::CVR::BallotMeasureContest, CVRV1::CVR::BallotMeasureSelection, CVRV1::CVR::CandidateContest, CVRV1::CVR::CandidateSelection, CVRV1::CVR::RetentionContest]
classes.each {|c| 
  c.include ROXML
}

def parse_datetime(time_string)
  valid_xml_date_without_timezone = (time_string =~ /^\d{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))$/)
  valid_xml_date_with_timezone = (time_string =~ /^\d{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])T(([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]|(24:00:00))(Z|[+-]((0[0-9]|1[0-3]):[0-5][0-9]|14:00))$/)
  if valid_xml_date_without_timezone
    default_timezone = $default_timezone || 'UTC'
    puts "Warning: timestamp #{time_string} does not include timezone information. Assuming '#{default_timezone}'."
    Time.parse("#{time_string} #{default_timezone}")
  elsif valid_xml_date_with_timezone
    Time.parse(time_string)
  else
    raise "Invalid dateTime detected: #{time_string}"
  end
end

module CVRV1::CVR
  class Annotation
    xml_name('Annotation')
    xml_attr('adjudicator_names', :as => [], :from => 'AdjudicatorName')
    xml_attr('messages', :as => [], :from => 'Message')
    xml_attr('time_stamp', :from => 'TimeStamp', :to_xml => proc{|v| v.strftime('%Y-%m-%dT%H:%M:%S%:z') if v}) {|v| parse_datetime(v)}
  end
  class BallotMeasureContest < CVRV1::CVR::Contest
    xml_name('BallotMeasureContest')
  end
  class BallotMeasureSelection < CVRV1::CVR::ContestSelection
    xml_name('BallotMeasureSelection')
    xml_attr('selection', :from => 'Selection')
  end
  class CVR
    xml_name('CVR')
    xml_attr('ballot_audit_id', :from => 'BallotAuditId')
    xml_attr('ballot_images', :as => [CVRV1::CVR::ImageData], :from => 'BallotImage', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('ballot_pre_printed_id', :from => 'BallotPrePrintedId')
    xml_attr('ballot_sheet_id', :from => 'BallotSheetId')
    xml_attr('ballot_style_id', :from => 'BallotStyleId')
    xml_attr('ballot_style_unit_id', :from => 'BallotStyleUnitId')
    xml_attr('batch_id', :from => 'BatchId')
    xml_attr('batch_sequence_id', :as => Integer, :from => 'BatchSequenceId')
    xml_attr('creating_device_id', :from => 'CreatingDeviceId')
    xml_attr('current_snapshot_id', :from => 'CurrentSnapshotId')
    xml_attr('cvr_snapshots', :as => [CVRV1::CVR::CVRSnapshot], :from => 'CVRSnapshot', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('election_id', :from => 'ElectionId')
    xml_attr('party_ids', :as => [], :from => 'PartyIds', :to_xml => proc{|v| v.empty? ? nil : v.join(' ')}) {|v| v.to_s.split(/ +/).uniq }
    xml_attr('unique_id', :from => 'UniqueId')
  end
  class CVRContest
    xml_name('CVRContest')
    xml_attr('contest_id', :from => 'ContestId')
    xml_attr('cvr_contest_selections', :as => [CVRV1::CVR::CVRContestSelection], :from => 'CVRContestSelection', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('overvotes', :as => Integer, :from => 'Overvotes')
    xml_attr('selections', :as => Integer, :from => 'Selections')
    xml_attr('statuses', :as => [], :from => 'Status', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('other_status', :from => 'OtherStatus')
    xml_attr('undervotes', :as => Integer, :from => 'Undervotes')
    xml_attr('write_ins', :as => Integer, :from => 'WriteIns')
  end
  class CVRContestSelection
    xml_name('CVRContestSelection')
    xml_attr('contest_selection_id', :from => 'ContestSelectionId')
    xml_attr('option_position', :as => Integer, :from => 'OptionPosition')
    xml_attr('rank', :as => Integer, :from => 'Rank')
    xml_attr('selection_positions', :as => [CVRV1::CVR::SelectionPosition], :from => 'SelectionPosition', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('statuses', :as => [], :from => 'Status', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('other_status', :from => 'OtherStatus')
    xml_attr('total_fractional_votes', :from => 'TotalFractionalVotes')
    xml_attr('total_number_votes', :as => Integer, :from => 'TotalNumberVotes')
  end
  class CVRSnapshot
    xml_name('CVRSnapshot')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('annotations', :as => [CVRV1::CVR::Annotation], :from => 'Annotation', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('cvr_contests', :as => [CVRV1::CVR::CVRContest], :from => 'CVRContest', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('statuses', :as => [], :from => 'Status', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('other_status', :from => 'OtherStatus')
    xml_attr('type', :from => 'Type')
  end
  class CVRWriteIn
    xml_name('CVRWriteIn')
    xml_attr('text', :from => 'Text')
    xml_attr('write_in_image', :as => CVRV1::CVR::ImageData, :from => 'WriteInImage')
  end
  class Candidate
    xml_name('Candidate')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('name', :from => 'Name')
    xml_attr('party_id', :from => 'PartyId')
  end
  class CandidateContest < CVRV1::CVR::Contest
    xml_name('CandidateContest')
    xml_attr('number_elected', :as => Integer, :from => 'NumberElected')
    xml_attr('primary_party_id', :from => 'PrimaryPartyId')
    xml_attr('votes_allowed', :as => Integer, :from => 'VotesAllowed')
  end
  class CandidateSelection < CVRV1::CVR::ContestSelection
    xml_name('CandidateSelection')
    xml_attr('candidate_ids', :as => [], :from => 'CandidateIds', :to_xml => proc{|v| v.empty? ? nil : v.join(' ')}) {|v| v.to_s.split(/ +/).uniq }
    xml_attr('is_write_in', :as => :bool, :from => 'IsWriteIn')
  end
  class CastVoteRecordReport
    xml_name('CastVoteRecordReport')
    xml_attr('cvrs', :as => [CVRV1::CVR::CVR], :from => 'CVR', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('elections', :as => [CVRV1::CVR::Election], :from => 'Election', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('generated_date', :from => 'GeneratedDate', :to_xml => proc{|v| v.strftime('%Y-%m-%dT%H:%M:%S%:z') if v}) {|v| parse_datetime(v)}
    xml_attr('gp_units', :as => [CVRV1::CVR::GpUnit], :from => 'GpUnit', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('notes', :from => 'Notes')
    xml_attr('parties', :as => [CVRV1::CVR::Party], :from => 'Party', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('report_generating_device_ids', :as => [], :from => 'ReportGeneratingDeviceIds', :to_xml => proc{|v| v.empty? ? nil : v.join(' ')}) {|v| v.to_s.split(/ +/).uniq }
    xml_attr('reporting_devices', :as => [CVRV1::CVR::ReportingDevice], :from => 'ReportingDevice', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('report_types', :as => [], :from => 'ReportType', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('other_report_type', :from => 'OtherReportType')
    xml_attr('version', :from => 'Version')
  end
  class Code
    xml_name('Code')
    xml_attr('label', :from => 'Label')
    xml_attr('type', :from => 'Type')
    xml_attr('other_type', :from => 'OtherType')
    xml_attr('value', :from => 'Value')
  end
  class Contest
    xml_name('Contest')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('abbreviation', :from => 'Abbreviation')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('contest_selections', :as => [CVRV1::CVR::ContestSelection], :from => 'ContestSelection', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('name', :from => 'Name')
    xml_attr('vote_variation', :from => 'VoteVariation')
    xml_attr('other_vote_variation', :from => 'OtherVoteVariation')
  end
  class ContestSelection
    xml_name('ContestSelection')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
  end
  class Election
    xml_name('Election')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('candidates', :as => [CVRV1::CVR::Candidate], :from => 'Candidate', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('contests', :as => [CVRV1::CVR::Contest], :from => 'Contest', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('election_scope_id', :from => 'ElectionScopeId')
    xml_attr('name', :from => 'Name')
  end
  class File
    xml_name('File')
    xml_attr('file_name', :from => '@FileName')
    xml_attr('mime_type', :from => '@MimeType')
    xml_attr('data', :as => ByteString, :from => :content)
  end
  class GpUnit
    xml_name('GpUnit')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('name', :from => 'Name')
    xml_attr('reporting_device_ids', :as => [], :from => 'ReportingDeviceIds', :to_xml => proc{|v| v.empty? ? nil : v.join(' ')}) {|v| v.to_s.split(/ +/).uniq }
    xml_attr('type', :from => 'Type')
    xml_attr('other_type', :from => 'OtherType')
  end
  class Hash
    xml_name('Hash')
    xml_attr('type', :from => 'Type')
    xml_attr('other_type', :from => 'OtherType')
    xml_attr('value', :from => 'Value')
  end
  class Image < CVRV1::CVR::File
    xml_name('Image')
  end
  class ImageData
    xml_name('ImageData')
    xml_attr('hash', :as => CVRV1::CVR::Hash, :from => 'Hash')
    xml_attr('image', :as => CVRV1::CVR::Image, :from => 'Image')
    xml_attr('location', :from => 'Location')
  end
  class Party
    xml_name('Party')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('abbreviation', :from => 'Abbreviation')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('name', :from => 'Name')
  end
  class PartyContest < CVRV1::CVR::Contest
    xml_name('PartyContest')
  end
  class PartySelection < CVRV1::CVR::ContestSelection
    xml_name('PartySelection')
    xml_attr('party_ids', :as => [], :from => 'PartyIds', :to_xml => proc{|v| v.empty? ? nil : v.join(' ')}) {|v| v.to_s.split(/ +/).uniq }
  end
  class ReportingDevice
    xml_name('ReportingDevice')
    xml_attr('id', :from => '@ObjectId')
    xml_attr('application', :from => 'Application')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('manufacturer', :from => 'Manufacturer')
    xml_attr('mark_metric_type', :from => 'MarkMetricType')
    xml_attr('model', :from => 'Model')
    xml_attr('notes', :as => [], :from => 'Notes')
    xml_attr('serial_number', :from => 'SerialNumber')
  end
  class RetentionContest < CVRV1::CVR::BallotMeasureContest
    xml_name('RetentionContest')
    xml_attr('candidate_id', :from => 'CandidateId')
  end
  class SelectionPosition
    xml_name('SelectionPosition')
    xml_attr('codes', :as => [CVRV1::CVR::Code], :from => 'Code', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('cvr_write_in', :as => CVRV1::CVR::CVRWriteIn, :from => 'CVRWriteIn')
    xml_attr('fractional_votes', :from => 'FractionalVotes')
    xml_attr('has_indication', :from => 'HasIndication')
    xml_attr('is_allocable', :from => 'IsAllocable')
    xml_attr('is_generated', :as => :bool, :from => 'IsGenerated')
    xml_attr('mark_metric_values', :as => [], :from => 'MarkMetricValue')
    xml_attr('number_votes', :as => Integer, :from => 'NumberVotes')
    xml_attr('position', :as => Integer, :from => 'Position')
    xml_attr('rank', :as => Integer, :from => 'Rank')
    xml_attr('statuses', :as => [], :from => 'Status', :to_xml => proc{|v| (v && v.empty?) ? nil : v})
    xml_attr('other_status', :from => 'OtherStatus')
  end
end
