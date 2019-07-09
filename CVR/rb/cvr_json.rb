require 'json_binding'

module CVRV1
end

JsonBinding.namespaces[CVRV1::CVR] = 'CVR'

module CVRV1::CVR
  class Annotation
    include JsonBinding
    json_attr :adjudicator_names, :as => 'AdjudicatorName', :default => []
    json_attr :messages, :as => 'Message', :default => []
    json_attr :time_stamp, :as => 'TimeStamp', :type => :datetime
  end
  class BallotMeasureContest < CVRV1::CVR::Contest
    include JsonBinding
  end
  class BallotMeasureSelection < CVRV1::CVR::ContestSelection
    include JsonBinding
    json_attr :selection, :as => 'Selection'
  end
  class CVR
    include JsonBinding
    json_attr :ballot_audit_id, :as => 'BallotAuditId'
    json_attr :ballot_images, :as => 'BallotImage', :default => [], :type => 'CVRV1::CVR::ImageData'
    json_attr :ballot_pre_printed_id, :as => 'BallotPrePrintedId'
    json_attr :ballot_sheet_id, :as => 'BallotSheetId'
    json_attr :ballot_style_id, :as => 'BallotStyleId'
    json_attr :ballot_style_unit_id, :as => 'BallotStyleUnitId'
    json_attr :batch_id, :as => 'BatchId'
    json_attr :batch_sequence_id, :as => 'BatchSequenceId'
    json_attr :creating_device_id, :as => 'CreatingDeviceId'
    json_attr :current_snapshot_id, :as => 'CurrentSnapshotId'
    json_attr :cvr_snapshots, :as => 'CVRSnapshot', :default => [], :type => 'CVRV1::CVR::CVRSnapshot'
    json_attr :election_id, :as => 'ElectionId'
    json_attr :party_ids, :as => 'PartyIds', :default => []
    json_attr :unique_id, :as => 'UniqueId'
  end
  class CVRContest
    include JsonBinding
    json_attr :contest_id, :as => 'ContestId'
    json_attr :cvr_contest_selections, :as => 'CVRContestSelection', :default => [], :type => 'CVRV1::CVR::CVRContestSelection'
    json_attr :other_status, :as => 'OtherStatus'
    json_attr :overvotes, :as => 'Overvotes'
    json_attr :selections, :as => 'Selections'
    json_attr :statuses, :as => 'Status', :default => []
    json_attr :undervotes, :as => 'Undervotes'
    json_attr :write_ins, :as => 'WriteIns'
  end
  class CVRContestSelection
    include JsonBinding
    json_attr :contest_selection_id, :as => 'ContestSelectionId'
    json_attr :option_position, :as => 'OptionPosition'
    json_attr :other_status, :as => 'OtherStatus'
    json_attr :rank, :as => 'Rank'
    json_attr :selection_positions, :as => 'SelectionPosition', :default => [], :type => 'CVRV1::CVR::SelectionPosition'
    json_attr :statuses, :as => 'Status', :default => []
    json_attr :total_fractional_votes, :as => 'TotalFractionalVotes'
    json_attr :total_number_votes, :as => 'TotalNumberVotes'
  end
  class CVRSnapshot
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :annotations, :as => 'Annotation', :default => [], :type => 'CVRV1::CVR::Annotation'
    json_attr :cvr_contests, :as => 'CVRContest', :default => [], :type => 'CVRV1::CVR::CVRContest'
    json_attr :other_status, :as => 'OtherStatus'
    json_attr :statuses, :as => 'Status', :default => []
    json_attr :type, :as => 'Type'
  end
  class CVRWriteIn
    include JsonBinding
    json_attr :text, :as => 'Text'
    json_attr :write_in_image, :as => 'WriteInImage', :type => 'CVRV1::CVR::ImageData'
  end
  class Candidate
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :name, :as => 'Name'
    json_attr :party_id, :as => 'PartyId'
  end
  class CandidateContest < CVRV1::CVR::Contest
    include JsonBinding
    json_attr :number_elected, :as => 'NumberElected'
    json_attr :primary_party_id, :as => 'PrimaryPartyId'
    json_attr :votes_allowed, :as => 'VotesAllowed'
  end
  class CandidateSelection < CVRV1::CVR::ContestSelection
    include JsonBinding
    json_attr :candidate_ids, :as => 'CandidateIds', :default => []
    json_attr :is_write_in, :as => 'IsWriteIn'
  end
  class CastVoteRecordReport
    include JsonBinding
    json_attr :cvrs, :as => 'CVR', :default => [], :type => 'CVRV1::CVR::CVR'
    json_attr :elections, :as => 'Election', :default => [], :type => 'CVRV1::CVR::Election'
    json_attr :generated_date, :as => 'GeneratedDate', :type => :datetime
    json_attr :gp_units, :as => 'GpUnit', :default => [], :type => 'CVRV1::CVR::GpUnit'
    json_attr :notes, :as => 'Notes'
    json_attr :other_report_type, :as => 'OtherReportType'
    json_attr :parties, :as => 'Party', :default => [], :type => 'CVRV1::CVR::Party'
    json_attr :report_generating_device_ids, :as => 'ReportGeneratingDeviceIds', :default => []
    json_attr :report_types, :as => 'ReportType', :default => []
    json_attr :reporting_devices, :as => 'ReportingDevice', :default => [], :type => 'CVRV1::CVR::ReportingDevice'
    json_attr :version, :as => 'Version'
  end
  class Code
    include JsonBinding
    json_attr :label, :as => 'Label'
    json_attr :other_type, :as => 'OtherType'
    json_attr :type, :as => 'Type'
    json_attr :value, :as => 'Value'
  end
  class Contest
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :abbreviation, :as => 'Abbreviation'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :contest_selections, :as => 'ContestSelection', :default => [], :type => 'CVRV1::CVR::ContestSelection'
    json_attr :name, :as => 'Name'
    json_attr :other_vote_variation, :as => 'OtherVoteVariation'
    json_attr :vote_variation, :as => 'VoteVariation'
  end
  class ContestSelection
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
  end
  class Election
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :candidates, :as => 'Candidate', :default => [], :type => 'CVRV1::CVR::Candidate'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :contests, :as => 'Contest', :default => [], :type => 'CVRV1::CVR::Contest'
    json_attr :election_scope_id, :as => 'ElectionScopeId'
    json_attr :name, :as => 'Name'
  end
  class File
    include JsonBinding
    json_attr :data, :as => 'Data'
    json_attr :file_name, :as => 'FileName'
    json_attr :mime_type, :as => 'MimeType'
  end
  class GpUnit
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :name, :as => 'Name'
    json_attr :other_type, :as => 'OtherType'
    json_attr :reporting_device_ids, :as => 'ReportingDeviceIds', :default => []
    json_attr :type, :as => 'Type'
  end
  class Hash
    include JsonBinding
    json_attr :other_type, :as => 'OtherType'
    json_attr :type, :as => 'Type'
    json_attr :value, :as => 'Value'
  end
  class Image < CVRV1::CVR::File
    include JsonBinding
  end
  class ImageData
    include JsonBinding
    json_attr :hash, :as => 'Hash', :type => 'CVRV1::CVR::Hash'
    json_attr :image, :as => 'Image', :type => 'CVRV1::CVR::Image'
    json_attr :location, :as => 'Location'
  end
  class Party
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :abbreviation, :as => 'Abbreviation'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :name, :as => 'Name'
  end
  class PartyContest < CVRV1::CVR::Contest
    include JsonBinding
  end
  class PartySelection < CVRV1::CVR::ContestSelection
    include JsonBinding
    json_attr :party_ids, :as => 'PartyIds', :default => []
  end
  class ReportingDevice
    include JsonBinding
    json_attr :id, :as => '@id'
    json_attr :application, :as => 'Application'
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :manufacturer, :as => 'Manufacturer'
    json_attr :mark_metric_type, :as => 'MarkMetricType'
    json_attr :model, :as => 'Model'
    json_attr :notes, :as => 'Notes', :default => []
    json_attr :serial_number, :as => 'SerialNumber'
  end
  class RetentionContest < CVRV1::CVR::BallotMeasureContest
    include JsonBinding
    json_attr :candidate_id, :as => 'CandidateId'
  end
  class SelectionPosition
    include JsonBinding
    json_attr :codes, :as => 'Code', :default => [], :type => 'CVRV1::CVR::Code'
    json_attr :cvr_write_in, :as => 'CVRWriteIn', :type => 'CVRV1::CVR::CVRWriteIn'
    json_attr :fractional_votes, :as => 'FractionalVotes'
    json_attr :has_indication, :as => 'HasIndication'
    json_attr :is_allocable, :as => 'IsAllocable'
    json_attr :is_generated, :as => 'IsGenerated'
    json_attr :mark_metric_values, :as => 'MarkMetricValue', :default => []
    json_attr :number_votes, :as => 'NumberVotes'
    json_attr :other_status, :as => 'OtherStatus'
    json_attr :position, :as => 'Position'
    json_attr :rank, :as => 'Rank'
    json_attr :statuses, :as => 'Status', :default => []
  end
end
