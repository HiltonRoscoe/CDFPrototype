require 'domain_model'

module CVRV1
  include DomainModel
  set_version 0
end

module CVRV1::CVR
  class Annotation
    include DomainModel
  property :adjudicator_names, :multiple => true
  property :messages, :multiple => true
  property :time_stamp
  end
  class CVR
    include DomainModel
  property :ballot_audit_id
  property :ballot_images, :multiple => true
  property :ballot_pre_printed_id
  property :ballot_sheet_id
  property :ballot_style_id
  property :ballot_style_unit_id
  property :batch_id
  property :batch_sequence_id
  property :creating_device_id
  property :current_snapshot_id
  property :cvr_snapshots, :multiple => true
  property :election_id
  property :party_ids, :multiple => true
  property :unique_id
  end
  class CVRContest
    include DomainModel
  property :contest_id
  property :cvr_contest_selections, :multiple => true
  property :other_status
  property :overvotes
  property :selections
  property :statuses, :multiple => true
  property :undervotes
  property :write_ins
  end
  class CVRContestSelection
    include DomainModel
  property :contest_selection_id
  property :option_position
  property :other_status
  property :rank
  property :selection_positions, :multiple => true
  property :statuses, :multiple => true
  property :total_fractional_votes
  property :total_number_votes
  end
  class CVRSnapshot
    include DomainModel
    property :id
  property :annotations, :multiple => true
  property :cvr_contests, :multiple => true
  property :other_status
  property :statuses, :multiple => true
  property :type
  end
  class CVRWriteIn
    include DomainModel
  property :text
  property :write_in_image
  end
  class Candidate
    include DomainModel
    property :id
  property :codes, :multiple => true
  property :name
  property :party_id
  end
  class CastVoteRecordReport
    include DomainModel
  property :cvrs, :multiple => true
  property :elections, :multiple => true
  property :generated_date
  property :gp_units, :multiple => true
  property :notes
  property :other_report_type
  property :parties, :multiple => true
  property :report_generating_device_ids, :multiple => true
  property :report_types, :multiple => true
  property :reporting_devices, :multiple => true
  property :version
  end
  class Code
    include DomainModel
  property :label
  property :other_type
  property :type
  property :value
  end
  class Contest
    include DomainModel
    property :id
  property :abbreviation
  property :codes, :multiple => true
  property :contest_selections, :multiple => true
  property :name
  property :other_vote_variation
  property :vote_variation
  end
  class ContestSelection
    include DomainModel
    property :id
  property :codes, :multiple => true
  end
  class Election
    include DomainModel
    property :id
  property :candidates, :multiple => true
  property :codes, :multiple => true
  property :contests, :multiple => true
  property :election_scope_id
  property :name
  end
  class File
    include DomainModel
  property :data
  property :file_name
  property :mime_type
  end
  class GpUnit
    include DomainModel
    property :id
  property :codes, :multiple => true
  property :name
  property :other_type
  property :reporting_device_ids, :multiple => true
  property :type
  end
  class Hash
    include DomainModel
  property :other_type
  property :type
  property :value
  end
  class Image < CVRV1::CVR::File
    include DomainModel
  end
  class ImageData
    include DomainModel
  property :hash
  property :image
  property :location
  end
  class Party
    include DomainModel
    property :id
  property :abbreviation
  property :codes, :multiple => true
  property :name
  end
  class PartyContest < CVRV1::CVR::Contest
    include DomainModel
  end
  class PartySelection < CVRV1::CVR::ContestSelection
    include DomainModel
  property :party_ids, :multiple => true
  end
  class ReportingDevice
    include DomainModel
    property :id
  property :application
  property :codes, :multiple => true
  property :manufacturer
  property :mark_metric_type
  property :model
  property :notes, :multiple => true
  property :serial_number
  end
  class SelectionPosition
    include DomainModel
  property :codes, :multiple => true
  property :cvr_write_in
  property :fractional_votes
  property :has_indication
  property :is_allocable
  property :is_generated
  property :mark_metric_values, :multiple => true
  property :number_votes
  property :other_status
  property :position
  property :rank
  property :statuses, :multiple => true
  end
  class BallotMeasureContest < CVRV1::CVR::Contest
    include DomainModel
  end
  class BallotMeasureSelection < CVRV1::CVR::ContestSelection
    include DomainModel
  property :selection
  end
  class CandidateContest < CVRV1::CVR::Contest
    include DomainModel
  property :number_elected
  property :primary_party_id
  property :votes_allowed
  end
  class CandidateSelection < CVRV1::CVR::ContestSelection
    include DomainModel
  property :candidate_ids, :multiple => true
  property :is_write_in
  end
  class RetentionContest < CVRV1::CVR::BallotMeasureContest
    include DomainModel
  property :candidate_id
  end
end
