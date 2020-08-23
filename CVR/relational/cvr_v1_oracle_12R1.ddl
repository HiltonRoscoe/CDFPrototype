-- Generated by Oracle SQL Developer Data Modeler 19.4.0.350.1424
--   at:        2020-08-08 13:43:34 EDT
--   site:      Oracle Database 12cR2
--   type:      Oracle Database 12cR2


CREATE TABLE annotation (
    timestamp      TIMESTAMP,
    annotationid   NUMBER
        CONSTRAINT nnc_ann_ann_id NOT NULL,
    cvrsnapshotid  NUMBER
        CONSTRAINT nnc_ann_cvrs_cvrs_id NOT NULL
);

ALTER TABLE annotation ADD CONSTRAINT annotation_pk PRIMARY KEY ( annotationid );

CREATE TABLE annotationadjudicatorname (
    adjudicatorname  VARCHAR2(4000),
    annotationid     NUMBER
        CONSTRAINT nnc_aan_ann_ann_id NOT NULL
);

CREATE TABLE annotationmessage (
    message       VARCHAR2(4000),
    annotationid  NUMBER
        CONSTRAINT nnc_am_ann_ann_id NOT NULL
);

CREATE TABLE ballotmeasurecontest (
    contestid NUMBER
        CONSTRAINT nnc_bmc_con_con_id NOT NULL
);

ALTER TABLE ballotmeasurecontest ADD CONSTRAINT ballotmeasurecontest_pk PRIMARY KEY ( contestid );

CREATE TABLE ballotmeasureselection (
    contestselectionid  NUMBER
        CONSTRAINT nnc_bms_cons_cons_id NOT NULL,
    selection           VARCHAR2(4000)
        CONSTRAINT nnc_bms_selection NOT NULL
);

ALTER TABLE ballotmeasureselection ADD CONSTRAINT ballotmeasureselection_pk PRIMARY KEY ( contestselectionid );

CREATE TABLE candidate (
    name         VARCHAR2(4000),
    candidateid  NUMBER
        CONSTRAINT nnc_can_can_id NOT NULL,
    partyid      NUMBER,
    electionid   NUMBER
        CONSTRAINT nnc_can_ele_ele_id NOT NULL
);

ALTER TABLE candidate ADD CONSTRAINT candidate_pk PRIMARY KEY ( candidateid );

CREATE TABLE candidate_code (
    codeid       NUMBER
        CONSTRAINT nnc_can_code_codeid NOT NULL,
    candidateid  NUMBER
        CONSTRAINT nnc_can_code_can_can_id NOT NULL
);

ALTER TABLE candidate_code ADD CONSTRAINT can_code_pk PRIMARY KEY ( codeid,
                                                                    candidateid );

CREATE TABLE candidatecontest (
    contestid      NUMBER
        CONSTRAINT nnc_cac_con_con_id NOT NULL,
    numberelected  INTEGER,
    votesallowed   INTEGER,
    partyid        NUMBER
);

ALTER TABLE candidatecontest ADD CONSTRAINT candidatecontest_pk PRIMARY KEY ( contestid );

CREATE TABLE candidateselection (
    contestselectionid  NUMBER
        CONSTRAINT nnc_cas_cons_cons_id NOT NULL,
    iswritein           NUMBER
);

ALTER TABLE candidateselection ADD CONSTRAINT candidateselection_pk PRIMARY KEY ( contestselectionid );

CREATE TABLE candidateselection_candidate (
    candidateid         NUMBER
        CONSTRAINT nnc_cas_can_can_can_id NOT NULL,
    contestselectionid  NUMBER
        CONSTRAINT nnc_cas_can_cs_cons_cons_id NOT NULL
);

ALTER TABLE candidateselection_candidate ADD CONSTRAINT cas_can_pk PRIMARY KEY ( candidateid,
                                                                                 contestselectionid );

CREATE TABLE castvoterecordreport (
    generateddate           TIMESTAMP
        CONSTRAINT nnc_cvrr_generateddate NOT NULL,
    notes                   VARCHAR2(4000),
    otherreporttype         VARCHAR2(4000),
    version                 VARCHAR2(50)
        CONSTRAINT nnc_cvrr_version NOT NULL,
    castvoterecordreportid  NUMBER
        CONSTRAINT nnc_cvrr_cvrr_id NOT NULL
);

ALTER TABLE castvoterecordreport
    ADD CONSTRAINT ck_cvrr_version CHECK ( version IN (
        '1.0.0'
    ) );

ALTER TABLE castvoterecordreport ADD CONSTRAINT castvoterecordreport_pk PRIMARY KEY ( castvoterecordreportid );

CREATE TABLE castvoterecordreport_reportingdevice (
    reportingdeviceid       NUMBER
        CONSTRAINT nnc_cvrr_rd_rd_rd_id NOT NULL,
    castvoterecordreportid  NUMBER
        CONSTRAINT nnc_cvrr_rd_cvrr_cvrr_id NOT NULL
);

ALTER TABLE castvoterecordreport_reportingdevice ADD CONSTRAINT cvrr_rd_pk PRIMARY KEY ( reportingdeviceid,
                                                                                         castvoterecordreportid );

CREATE TABLE castvoterecordreportreporttype (
    reporttype              VARCHAR2(50),
    castvoterecordreportid  NUMBER
        CONSTRAINT nnc_cvrrt_cvrr_cvrr_id NOT NULL
);

ALTER TABLE castvoterecordreportreporttype
    ADD CONSTRAINT ck_cvrrt_reporttype CHECK ( reporttype IN (
        'adjudicated',
        'aggregated',
        'originating-device-export',
        'other',
        'rcv-round'
    ) );

CREATE TABLE code (
    label      VARCHAR2(4000),
    othertype  VARCHAR2(4000),
    type       VARCHAR2(50)
        CONSTRAINT nnc_code_type NOT NULL,
    value      VARCHAR2(4000)
        CONSTRAINT nnc_code_value NOT NULL,
    codeid     NUMBER
        CONSTRAINT nnc_code_codeid NOT NULL
);

ALTER TABLE code
    ADD CONSTRAINT ck_code_type CHECK ( type IN (
        'fips',
        'local-level',
        'national-level',
        'ocd-id',
        'other',
        'state-level'
    ) );

ALTER TABLE code ADD CONSTRAINT code_pk PRIMARY KEY ( codeid );

CREATE TABLE contest (
    contestid           NUMBER
        CONSTRAINT nnc_con_con_id NOT NULL,
    abbreviation        VARCHAR2(4000),
    name                VARCHAR2(4000),
    othervotevariation  VARCHAR2(4000),
    votevariation       VARCHAR2(50),
    electionid          NUMBER
        CONSTRAINT nnc_con_ele_ele_id NOT NULL
);

ALTER TABLE contest
    ADD CONSTRAINT ck_con_votevariation CHECK ( votevariation IN (
        'approval',
        'borda',
        'cumulative',
        'majority',
        'n-of-m',
        'other',
        'plurality',
        'proportional',
        'range',
        'rcv',
        'super-majority'
    ) );


ALTER TABLE contest ADD CONSTRAINT contest_pk PRIMARY KEY ( contestid );

CREATE TABLE contest_code (
    codeid     NUMBER
        CONSTRAINT nnc_con_code_codeid NOT NULL,
    contestid  NUMBER
        CONSTRAINT nnc_con_code_con_con_id NOT NULL
);

ALTER TABLE contest_code ADD CONSTRAINT con_code_pk PRIMARY KEY ( codeid,
                                                                  contestid );

CREATE TABLE contestselection (
    contestselectionid  NUMBER
        CONSTRAINT nnc_cons_cons_id NOT NULL,
    contestid           NUMBER
        CONSTRAINT nnc_cons_con_con_id NOT NULL
);

ALTER TABLE contestselection ADD CONSTRAINT contestselection_pk PRIMARY KEY ( contestselectionid );

CREATE TABLE contestselection_code (
    codeid              NUMBER
        CONSTRAINT nnc_cons_code_codeid NOT NULL,
    contestselectionid  NUMBER
        CONSTRAINT nnc_cons_code_cons_cons_id NOT NULL
);

ALTER TABLE contestselection_code ADD CONSTRAINT cons_code_pk PRIMARY KEY ( codeid,
                                                                            contestselectionid );

CREATE TABLE cvr (
    ballotauditid           VARCHAR2(4000),
    ballotpreprintedid      VARCHAR2(4000),
    ballotsheetid           VARCHAR2(4000),
    ballotstyleid           VARCHAR2(4000),
    batchid                 VARCHAR2(4000),
    batchsequenceid         INTEGER,
    uniqueid                VARCHAR2(4000),
    cvrid                   NUMBER
        CONSTRAINT nnc_cvr_cvrid NOT NULL,
    castvoterecordreportid  NUMBER
        CONSTRAINT nnc_cvr_cvrr_cvrr_id NOT NULL,
    electionid              NUMBER
        CONSTRAINT nnc_cvr_ele_ele_id NOT NULL,
    gpunitid                NUMBER,
    reportingdeviceid       NUMBER
);

ALTER TABLE cvr ADD CONSTRAINT cvr_pk PRIMARY KEY ( cvrid );

CREATE TABLE cvr_imagedata (
    imagedataid  NUMBER
        CONSTRAINT nnc_cvr_imagedata_imagedataid NOT NULL,
    cvrid        NUMBER
        CONSTRAINT nnc_cvr_imagedata_cvrid NOT NULL
);

ALTER TABLE cvr_imagedata ADD CONSTRAINT cvr_imagedata_pk PRIMARY KEY ( imagedataid,
                                                                        cvrid );

CREATE TABLE cvr_party (
    partyid  NUMBER
        CONSTRAINT nnc_cvr_par_par_par_id NOT NULL,
    cvrid    NUMBER
        CONSTRAINT nnc_cvr_par_cvrid NOT NULL
);

ALTER TABLE cvr_party ADD CONSTRAINT cvr_par_pk PRIMARY KEY ( partyid,
                                                              cvrid );

CREATE TABLE cvrcontest (
    otherstatus    VARCHAR2(4000),
    overvotes      INTEGER,
    selections     INTEGER,
    undervotes     INTEGER,
    writeins       INTEGER,
    cvrcontestid   NUMBER
        CONSTRAINT nnc_cc_cc_id NOT NULL,
    contestid      NUMBER
        CONSTRAINT nnc_cc_con_con_id NOT NULL,
    cvrsnapshotid  NUMBER
        CONSTRAINT nnc_cc_cvrs_cvrs_id NOT NULL
);

ALTER TABLE cvrcontest ADD CONSTRAINT cvrcontest_pk PRIMARY KEY ( cvrcontestid );

CREATE TABLE cvrcontestselection (
    optionposition         INTEGER,
    otherstatus            VARCHAR2(4000),
    rank                   INTEGER,
    totalfractionalvotes   VARCHAR2(4000),
    totalnumbervotes       INTEGER,
    cvrcontestselectionid  NUMBER
        CONSTRAINT nnc_ccs_ccs_id NOT NULL,
    cvrcontestid           NUMBER
        CONSTRAINT nnc_ccs_cc_cc_id NOT NULL,
    contestselectionid     NUMBER
);

ALTER TABLE cvrcontestselection ADD CONSTRAINT cvrcontestselection_pk PRIMARY KEY ( cvrcontestselectionid );

CREATE TABLE cvrcontestselectionstatus (
    status                 VARCHAR2(50),
    cvrcontestselectionid  NUMBER
        CONSTRAINT nnc_ccss_ccs_ccs_id NOT NULL
);

ALTER TABLE cvrcontestselectionstatus
    ADD CONSTRAINT ck_ccss_status CHECK ( status IN (
        'generated-rules',
        'invalidated-rules',
        'needs-adjudication',
        'other'
    ) );

CREATE TABLE cvrconteststatus (
    status        VARCHAR2(50),
    cvrcontestid  NUMBER
        CONSTRAINT nnc_cvrconteststatus_cc_cc_id NOT NULL
);

ALTER TABLE cvrconteststatus
    ADD CONSTRAINT ck_cvrconteststatus_status CHECK ( status IN (
        'invalidated-rules',
        'not-indicated',
        'other',
        'overvoted',
        'undervoted'
    ) );

CREATE TABLE cvrsnapshot (
    otherstatus    VARCHAR2(4000),
    type           VARCHAR2(50)
        CONSTRAINT nnc_cvrs_type NOT NULL,
    cvrsnapshotid  NUMBER
        CONSTRAINT nnc_cvrs_cvrs_id NOT NULL,
    cvrid          NUMBER
        CONSTRAINT nnc_cvrs_cvrid NOT NULL
);

ALTER TABLE cvrsnapshot
    ADD CONSTRAINT ck_cvrs_type CHECK ( type IN (
        'interpreted',
        'modified',
        'original'
    ) );

ALTER TABLE cvrsnapshot ADD CONSTRAINT cvrsnapshot_pk PRIMARY KEY ( cvrsnapshotid );

CREATE TABLE cvrsnapshotstatus (
    status         VARCHAR2(50),
    cvrsnapshotid  NUMBER
        CONSTRAINT nnc_css_cvrs_cvrs_id NOT NULL
);

ALTER TABLE cvrsnapshotstatus
    ADD CONSTRAINT ck_css_status CHECK ( status IN (
        'needs-adjudication',
        'other'
    ) );

CREATE TABLE cvrwritein (
    text                 VARCHAR2(4000),
    cvrwriteinid         NUMBER
        CONSTRAINT nnc_cwi_cvrwriteinid NOT NULL,
    selectionpositionid  NUMBER
        CONSTRAINT nnc_cwi_sp_sp_id NOT NULL
);

CREATE UNIQUE INDEX cwi_sp_sp_id_idx ON
    cvrwritein (
        selectionpositionid
    ASC );

ALTER TABLE cvrwritein ADD CONSTRAINT cvrwritein_pk PRIMARY KEY ( cvrwriteinid );

CREATE TABLE cvrwritein_imagedata (
    imagedataid   NUMBER
        CONSTRAINT nnc_cwi_imagedata_imagedataid NOT NULL,
    cvrwriteinid  NUMBER
        CONSTRAINT nnc_cwi_imagedata_cvrwriteinid NOT NULL
);

ALTER TABLE cvrwritein_imagedata ADD CONSTRAINT cwi_imagedata_pk PRIMARY KEY ( imagedataid,
                                                                               cvrwriteinid );

CREATE TABLE election (
    name        VARCHAR2(4000),
    electionid  NUMBER
        CONSTRAINT nnc_ele_ele_id NOT NULL,
    gpunitid    NUMBER
        CONSTRAINT nnc_ele_gpunitid NOT NULL
);

ALTER TABLE election ADD CONSTRAINT election_pk PRIMARY KEY ( electionid );

CREATE TABLE election_code (
    codeid      NUMBER
        CONSTRAINT nnc_ele_code_codeid NOT NULL,
    electionid  NUMBER
        CONSTRAINT nnc_ele_code_ele_ele_id NOT NULL
);

ALTER TABLE election_code ADD CONSTRAINT ele_code_pk PRIMARY KEY ( codeid,
                                                                   electionid );

CREATE TABLE "File" (
    fileid    NUMBER
        CONSTRAINT nnc_file_fileid NOT NULL,
    data      BLOB
        CONSTRAINT nnc_file_data NOT NULL,
    filename  VARCHAR2(4000),
    mimetype  VARCHAR2(4000)
);

ALTER TABLE "File" ADD CONSTRAINT file_pk PRIMARY KEY ( fileid );

CREATE TABLE gpunit (
    name       VARCHAR2(4000),
    othertype  VARCHAR2(4000),
    type       VARCHAR2(50)
        CONSTRAINT nnc_gpunit_type NOT NULL,
    gpunitid   NUMBER
        CONSTRAINT nnc_gpunit_gpunitid NOT NULL
);

ALTER TABLE gpunit
    ADD CONSTRAINT ck_gpunit_type CHECK ( type IN (
        'combined-precinct',
        'other',
        'polling-place',
        'precinct',
        'split-precinct',
        'vote-center'
    ) );

ALTER TABLE gpunit ADD CONSTRAINT gpunit_pk PRIMARY KEY ( gpunitid );

CREATE TABLE gpunit_code (
    codeid    NUMBER
        CONSTRAINT nnc_gpunit_code_codeid NOT NULL,
    gpunitid  NUMBER
        CONSTRAINT nnc_gpunit_code_gpunitid NOT NULL
);

ALTER TABLE gpunit_code ADD CONSTRAINT gpunit_code_pk PRIMARY KEY ( codeid,
                                                                    gpunitid );

CREATE TABLE gpunit_reportingdevice (
    reportingdeviceid  NUMBER
        CONSTRAINT nnc_gpunit_rd_rd_rd_id NOT NULL,
    gpunitid           NUMBER
        CONSTRAINT nnc_gpunit_rd_gpunitid NOT NULL
);

ALTER TABLE gpunit_reportingdevice ADD CONSTRAINT gpunit_rd_pk PRIMARY KEY ( reportingdeviceid,
                                                                             gpunitid );

CREATE TABLE hash (
    othertype    VARCHAR2(4000),
    type         VARCHAR2(50)
        CONSTRAINT nnc_hash_type NOT NULL,
    value        VARCHAR2(4000)
        CONSTRAINT nnc_hash_value NOT NULL,
    imagedataid  NUMBER
        CONSTRAINT nnc_hash_imagedataid NOT NULL
);

ALTER TABLE hash
    ADD CONSTRAINT ck_hash_type CHECK ( type IN (
        'md6',
        'other',
        'sha-256',
        'sha-512'
    ) );

CREATE UNIQUE INDEX hash_imagedataid_idx ON
    hash (
        imagedataid
    ASC );

CREATE TABLE image (
    fileid       NUMBER
        CONSTRAINT nnc_image_imageid NOT NULL,
    imagedataid  NUMBER
        CONSTRAINT nnc_image_imagedataid NOT NULL
);

CREATE UNIQUE INDEX image_imagedataid_idx ON
    image (
        imagedataid
    ASC );

ALTER TABLE image ADD CONSTRAINT image_pk PRIMARY KEY ( fileid );

CREATE TABLE imagedata (
    location     VARCHAR2(4000),
    imagedataid  NUMBER
        CONSTRAINT nnc_imagedata_imagedataid NOT NULL
);

ALTER TABLE imagedata ADD CONSTRAINT imagedata_pk PRIMARY KEY ( imagedataid );

CREATE TABLE party (
    abbreviation  VARCHAR2(4000),
    name          VARCHAR2(4000),
    partyid       NUMBER
        CONSTRAINT nnc_par_par_id NOT NULL
);

ALTER TABLE party ADD CONSTRAINT party_pk PRIMARY KEY ( partyid );

CREATE TABLE party_code (
    codeid   NUMBER
        CONSTRAINT nnc_par_code_codeid NOT NULL,
    partyid  NUMBER
        CONSTRAINT nnc_par_code_par_par_id NOT NULL
);

ALTER TABLE party_code ADD CONSTRAINT par_code_pk PRIMARY KEY ( codeid,
                                                                partyid );

CREATE TABLE partycontest (
    contestid NUMBER
        CONSTRAINT nnc_pc_con_con_id NOT NULL
);

ALTER TABLE partycontest ADD CONSTRAINT partycontest_pk PRIMARY KEY ( contestid );

CREATE TABLE partyselection (
    contestselectionid NUMBER
        CONSTRAINT nnc_ps_cons_cons_id NOT NULL
);

ALTER TABLE partyselection ADD CONSTRAINT partyselection_pk PRIMARY KEY ( contestselectionid );

CREATE TABLE partyselection_party (
    partyid             NUMBER
        CONSTRAINT nnc_ps_par_par_par_id NOT NULL,
    contestselectionid  NUMBER
        CONSTRAINT nnc_ps_par_ps_cons_cons_id NOT NULL
);

ALTER TABLE partyselection_party ADD CONSTRAINT ps_par_pk PRIMARY KEY ( partyid,
                                                                        contestselectionid );

CREATE TABLE reportingdevice (
    application        VARCHAR2(4000),
    manufacturer       VARCHAR2(4000),
    markmetrictype     VARCHAR2(4000),
    model              VARCHAR2(4000),
    serialnumber       VARCHAR2(4000),
    reportingdeviceid  NUMBER
        CONSTRAINT nnc_rd_rd_id NOT NULL
);

ALTER TABLE reportingdevice ADD CONSTRAINT reportingdevice_pk PRIMARY KEY ( reportingdeviceid );

CREATE TABLE reportingdevice_code (
    codeid             NUMBER
        CONSTRAINT nnc_rd_code_codeid NOT NULL,
    reportingdeviceid  NUMBER
        CONSTRAINT nnc_rd_code_rd_rd_id NOT NULL
);

ALTER TABLE reportingdevice_code ADD CONSTRAINT rd_code_pk PRIMARY KEY ( codeid,
                                                                         reportingdeviceid );

CREATE TABLE reportingdevicenotes (
    notes              VARCHAR2(4000),
    reportingdeviceid  NUMBER
        CONSTRAINT nnc_rdi_rd_rd_id NOT NULL
);

CREATE TABLE retentioncontest (
    contestid    NUMBER
        CONSTRAINT nnc_rc_bmc_con_con_id NOT NULL,
    candidateid  NUMBER
);

ALTER TABLE retentioncontest ADD CONSTRAINT retentioncontest_pk PRIMARY KEY ( contestid );

CREATE TABLE selectionposition (
    fractionalvotes        VARCHAR2(4000),
    hasindication          VARCHAR2(50)
        CONSTRAINT nnc_sp_hasindication NOT NULL,
    isallocable            VARCHAR2(50),
    isgenerated            NUMBER,
    numbervotes            INTEGER
        CONSTRAINT nnc_sp_numbervotes NOT NULL,
    otherstatus            VARCHAR2(4000),
    position               INTEGER,
    rank                   INTEGER,
    selectionpositionid    NUMBER
        CONSTRAINT nnc_sp_sp_id NOT NULL,
    cvrcontestselectionid  NUMBER
        CONSTRAINT nnc_sp_ccs_ccs_id NOT NULL
);

ALTER TABLE selectionposition
    ADD CONSTRAINT ck_sp_hasindication CHECK ( hasindication IN (
        'no',
        'unknown',
        'yes'
    ) );

ALTER TABLE selectionposition
    ADD CONSTRAINT ck_sp_isallocable CHECK ( isallocable IN (
        'no',
        'unknown',
        'yes'
    ) );

ALTER TABLE selectionposition ADD CONSTRAINT selectionposition_pk PRIMARY KEY ( selectionpositionid );

CREATE TABLE selectionposition_code (
    codeid               NUMBER
        CONSTRAINT nnc_sp_code_codeid NOT NULL,
    selectionpositionid  NUMBER
        CONSTRAINT nnc_sp_code_sp_sp_id NOT NULL
);

ALTER TABLE selectionposition_code ADD CONSTRAINT sp_code_pk PRIMARY KEY ( codeid,
                                                                           selectionpositionid );

CREATE TABLE selectionpositionmarkmetricvalue (
    markmetricvalue      VARCHAR2(4000),
    selectionpositionid  NUMBER
        CONSTRAINT nnc_spmmv_sp_sp_id NOT NULL
);

CREATE TABLE selectionpositionstatus (
    status               VARCHAR2(50),
    selectionpositionid  NUMBER
        CONSTRAINT nnc_sps_sp_sp_id NOT NULL
);

ALTER TABLE selectionpositionstatus
    ADD CONSTRAINT ck_sps_status CHECK ( status IN (
        'adjudicated',
        'generated-rules',
        'invalidated-rules',
        'other'
    ) );

ALTER TABLE annotationadjudicatorname
    ADD CONSTRAINT aan_ann_fk FOREIGN KEY ( annotationid )
        REFERENCES annotation ( annotationid );

ALTER TABLE annotationmessage
    ADD CONSTRAINT am_ann_fk FOREIGN KEY ( annotationid )
        REFERENCES annotation ( annotationid );

ALTER TABLE annotation
    ADD CONSTRAINT ann_cvrs_fk FOREIGN KEY ( cvrsnapshotid )
        REFERENCES cvrsnapshot ( cvrsnapshotid );

ALTER TABLE ballotmeasurecontest
    ADD CONSTRAINT bmc_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE ballotmeasureselection
    ADD CONSTRAINT bms_cons_fk FOREIGN KEY ( contestselectionid )
        REFERENCES contestselection ( contestselectionid );

ALTER TABLE candidatecontest
    ADD CONSTRAINT cac_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE candidatecontest
    ADD CONSTRAINT cac_par_fk FOREIGN KEY ( partyid )
        REFERENCES party ( partyid );

ALTER TABLE candidate_code
    ADD CONSTRAINT can_code_can_fk FOREIGN KEY ( candidateid )
        REFERENCES candidate ( candidateid );

ALTER TABLE candidate_code
    ADD CONSTRAINT can_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE candidate
    ADD CONSTRAINT can_ele_fk FOREIGN KEY ( electionid )
        REFERENCES election ( electionid );

ALTER TABLE candidate
    ADD CONSTRAINT can_par_fk FOREIGN KEY ( partyid )
        REFERENCES party ( partyid );

ALTER TABLE candidateselection_candidate
    ADD CONSTRAINT cas_can_can_fk FOREIGN KEY ( candidateid )
        REFERENCES candidate ( candidateid );

ALTER TABLE candidateselection_candidate
    ADD CONSTRAINT cas_can_cas_fk FOREIGN KEY ( contestselectionid )
        REFERENCES candidateselection ( contestselectionid );

ALTER TABLE candidateselection
    ADD CONSTRAINT cas_cons_fk FOREIGN KEY ( contestselectionid )
        REFERENCES contestselection ( contestselectionid );

ALTER TABLE cvrcontest
    ADD CONSTRAINT cc_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE cvrcontest
    ADD CONSTRAINT cc_cvrs_fk FOREIGN KEY ( cvrsnapshotid )
        REFERENCES cvrsnapshot ( cvrsnapshotid );

ALTER TABLE cvrcontestselection
    ADD CONSTRAINT ccs_cc_fk FOREIGN KEY ( cvrcontestid )
        REFERENCES cvrcontest ( cvrcontestid );

ALTER TABLE cvrcontestselection
    ADD CONSTRAINT ccs_cons_fk FOREIGN KEY ( contestselectionid )
        REFERENCES contestselection ( contestselectionid );

ALTER TABLE cvrcontestselectionstatus
    ADD CONSTRAINT ccss_ccs_fk FOREIGN KEY ( cvrcontestselectionid )
        REFERENCES cvrcontestselection ( cvrcontestselectionid );

ALTER TABLE contest_code
    ADD CONSTRAINT con_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE contest_code
    ADD CONSTRAINT con_code_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE contest
    ADD CONSTRAINT con_ele_fk FOREIGN KEY ( electionid )
        REFERENCES election ( electionid );

ALTER TABLE contestselection_code
    ADD CONSTRAINT cons_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE contestselection_code
    ADD CONSTRAINT cons_code_cons_fk FOREIGN KEY ( contestselectionid )
        REFERENCES contestselection ( contestselectionid );

ALTER TABLE contestselection
    ADD CONSTRAINT cons_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE cvrsnapshotstatus
    ADD CONSTRAINT css_cvrs_fk FOREIGN KEY ( cvrsnapshotid )
        REFERENCES cvrsnapshot ( cvrsnapshotid );

ALTER TABLE cvr
    ADD CONSTRAINT cvr_cvrr_fk FOREIGN KEY ( castvoterecordreportid )
        REFERENCES castvoterecordreport ( castvoterecordreportid );

ALTER TABLE cvr
    ADD CONSTRAINT cvr_ele_fk FOREIGN KEY ( electionid )
        REFERENCES election ( electionid );

ALTER TABLE cvr
    ADD CONSTRAINT cvr_gpunit_fk FOREIGN KEY ( gpunitid )
        REFERENCES gpunit ( gpunitid );

ALTER TABLE cvr_imagedata
    ADD CONSTRAINT cvr_imagedata_cvr_fk FOREIGN KEY ( cvrid )
        REFERENCES cvr ( cvrid );

ALTER TABLE cvr_imagedata
    ADD CONSTRAINT cvr_imagedata_imagedata_fk FOREIGN KEY ( imagedataid )
        REFERENCES imagedata ( imagedataid );

ALTER TABLE cvr_party
    ADD CONSTRAINT cvr_par_cvr_fk FOREIGN KEY ( cvrid )
        REFERENCES cvr ( cvrid );

ALTER TABLE cvr_party
    ADD CONSTRAINT cvr_par_par_fk FOREIGN KEY ( partyid )
        REFERENCES party ( partyid );

ALTER TABLE cvr
    ADD CONSTRAINT cvr_rd_fk FOREIGN KEY ( reportingdeviceid )
        REFERENCES reportingdevice ( reportingdeviceid );

ALTER TABLE cvrconteststatus
    ADD CONSTRAINT cvrconteststatus_cc_fk FOREIGN KEY ( cvrcontestid )
        REFERENCES cvrcontest ( cvrcontestid );

ALTER TABLE castvoterecordreport_reportingdevice
    ADD CONSTRAINT cvrr_rd_cvrr_fk FOREIGN KEY ( castvoterecordreportid )
        REFERENCES castvoterecordreport ( castvoterecordreportid );

ALTER TABLE castvoterecordreport_reportingdevice
    ADD CONSTRAINT cvrr_rd_rd_fk FOREIGN KEY ( reportingdeviceid )
        REFERENCES reportingdevice ( reportingdeviceid );

ALTER TABLE castvoterecordreportreporttype
    ADD CONSTRAINT cvrrt_cvrr_fk FOREIGN KEY ( castvoterecordreportid )
        REFERENCES castvoterecordreport ( castvoterecordreportid );

ALTER TABLE cvrsnapshot
    ADD CONSTRAINT cvrs_cvr_fk FOREIGN KEY ( cvrid )
        REFERENCES cvr ( cvrid );

ALTER TABLE cvrwritein_imagedata
    ADD CONSTRAINT cwi_imagedata_cwi_fk FOREIGN KEY ( cvrwriteinid )
        REFERENCES cvrwritein ( cvrwriteinid );

ALTER TABLE cvrwritein_imagedata
    ADD CONSTRAINT cwi_imagedata_imagedata_fk FOREIGN KEY ( imagedataid )
        REFERENCES imagedata ( imagedataid );

ALTER TABLE cvrwritein
    ADD CONSTRAINT cwi_sp_fk FOREIGN KEY ( selectionpositionid )
        REFERENCES selectionposition ( selectionpositionid );

ALTER TABLE election_code
    ADD CONSTRAINT ele_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE election_code
    ADD CONSTRAINT ele_code_ele_fk FOREIGN KEY ( electionid )
        REFERENCES election ( electionid );

ALTER TABLE election
    ADD CONSTRAINT ele_gpunit_fk FOREIGN KEY ( gpunitid )
        REFERENCES gpunit ( gpunitid );

ALTER TABLE gpunit_code
    ADD CONSTRAINT gpunit_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE gpunit_code
    ADD CONSTRAINT gpunit_code_gpunit_fk FOREIGN KEY ( gpunitid )
        REFERENCES gpunit ( gpunitid );

ALTER TABLE gpunit_reportingdevice
    ADD CONSTRAINT gpunit_rd_gpunit_fk FOREIGN KEY ( gpunitid )
        REFERENCES gpunit ( gpunitid );

ALTER TABLE gpunit_reportingdevice
    ADD CONSTRAINT gpunit_rd_rd_fk FOREIGN KEY ( reportingdeviceid )
        REFERENCES reportingdevice ( reportingdeviceid );

ALTER TABLE hash
    ADD CONSTRAINT hash_imagedata_fk FOREIGN KEY ( imagedataid )
        REFERENCES imagedata ( imagedataid );

ALTER TABLE image
    ADD CONSTRAINT image_file_fk FOREIGN KEY ( fileid )
        REFERENCES "File" ( fileid );

ALTER TABLE image
    ADD CONSTRAINT image_imagedata_fk FOREIGN KEY ( imagedataid )
        REFERENCES imagedata ( imagedataid );

ALTER TABLE party_code
    ADD CONSTRAINT par_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE party_code
    ADD CONSTRAINT par_code_par_fk FOREIGN KEY ( partyid )
        REFERENCES party ( partyid );

ALTER TABLE partycontest
    ADD CONSTRAINT pc_con_fk FOREIGN KEY ( contestid )
        REFERENCES contest ( contestid );

ALTER TABLE partyselection
    ADD CONSTRAINT ps_cons_fk FOREIGN KEY ( contestselectionid )
        REFERENCES contestselection ( contestselectionid );

ALTER TABLE partyselection_party
    ADD CONSTRAINT ps_par_par_fk FOREIGN KEY ( partyid )
        REFERENCES party ( partyid );

ALTER TABLE partyselection_party
    ADD CONSTRAINT ps_par_ps_fk FOREIGN KEY ( contestselectionid )
        REFERENCES partyselection ( contestselectionid );

ALTER TABLE retentioncontest
    ADD CONSTRAINT rc_bmc_fk FOREIGN KEY ( contestid )
        REFERENCES ballotmeasurecontest ( contestid );

ALTER TABLE retentioncontest
    ADD CONSTRAINT rc_can_fk FOREIGN KEY ( candidateid )
        REFERENCES candidate ( candidateid );

ALTER TABLE reportingdevice_code
    ADD CONSTRAINT rd_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE reportingdevice_code
    ADD CONSTRAINT rd_code_rd_fk FOREIGN KEY ( reportingdeviceid )
        REFERENCES reportingdevice ( reportingdeviceid );

ALTER TABLE reportingdevicenotes
    ADD CONSTRAINT rdi_rd_fk FOREIGN KEY ( reportingdeviceid )
        REFERENCES reportingdevice ( reportingdeviceid );

ALTER TABLE selectionposition
    ADD CONSTRAINT sp_ccs_fk FOREIGN KEY ( cvrcontestselectionid )
        REFERENCES cvrcontestselection ( cvrcontestselectionid );

ALTER TABLE selectionposition_code
    ADD CONSTRAINT sp_code_code_fk FOREIGN KEY ( codeid )
        REFERENCES code ( codeid );

ALTER TABLE selectionposition_code
    ADD CONSTRAINT sp_code_sp_fk FOREIGN KEY ( selectionpositionid )
        REFERENCES selectionposition ( selectionpositionid );

ALTER TABLE selectionpositionmarkmetricvalue
    ADD CONSTRAINT spmmv_sp_fk FOREIGN KEY ( selectionpositionid )
        REFERENCES selectionposition ( selectionpositionid );

ALTER TABLE selectionpositionstatus
    ADD CONSTRAINT sps_sp_fk FOREIGN KEY ( selectionpositionid )
        REFERENCES selectionposition ( selectionpositionid );

CREATE SEQUENCE ann_ann_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER ann_ann_id_trg BEFORE
    INSERT ON annotation
    FOR EACH ROW
    WHEN ( new.annotationid IS NULL )
BEGIN
    :new.annotationid := ann_ann_id_seq.nextval;
END;
/

CREATE SEQUENCE can_can_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER can_can_id_trg BEFORE
    INSERT ON candidate
    FOR EACH ROW
    WHEN ( new.candidateid IS NULL )
BEGIN
    :new.candidateid := can_can_id_seq.nextval;
END;
/

CREATE SEQUENCE cvrr_cvrr_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cvrr_cvrr_id_trg BEFORE
    INSERT ON castvoterecordreport
    FOR EACH ROW
    WHEN ( new.castvoterecordreportid IS NULL )
BEGIN
    :new.castvoterecordreportid := cvrr_cvrr_id_seq.nextval;
END;
/

CREATE SEQUENCE code_codeid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER code_codeid_trg BEFORE
    INSERT ON code
    FOR EACH ROW
    WHEN ( new.codeid IS NULL )
BEGIN
    :new.codeid := code_codeid_seq.nextval;
END;
/

CREATE SEQUENCE con_con_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER con_con_id_trg BEFORE
    INSERT ON contest
    FOR EACH ROW
    WHEN ( new.contestid IS NULL )
BEGIN
    :new.contestid := con_con_id_seq.nextval;
END;
/

CREATE SEQUENCE cons_cons_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cons_cons_id_trg BEFORE
    INSERT ON contestselection
    FOR EACH ROW
    WHEN ( new.contestselectionid IS NULL )
BEGIN
    :new.contestselectionid := cons_cons_id_seq.nextval;
END;
/

CREATE SEQUENCE cvr_cvrid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cvr_cvrid_trg BEFORE
    INSERT ON cvr
    FOR EACH ROW
    WHEN ( new.cvrid IS NULL )
BEGIN
    :new.cvrid := cvr_cvrid_seq.nextval;
END;
/

CREATE SEQUENCE cc_cc_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cc_cc_id_trg BEFORE
    INSERT ON cvrcontest
    FOR EACH ROW
    WHEN ( new.cvrcontestid IS NULL )
BEGIN
    :new.cvrcontestid := cc_cc_id_seq.nextval;
END;
/

CREATE SEQUENCE ccs_ccs_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER ccs_ccs_id_trg BEFORE
    INSERT ON cvrcontestselection
    FOR EACH ROW
    WHEN ( new.cvrcontestselectionid IS NULL )
BEGIN
    :new.cvrcontestselectionid := ccs_ccs_id_seq.nextval;
END;
/

CREATE SEQUENCE cvrs_cvrs_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cvrs_cvrs_id_trg BEFORE
    INSERT ON cvrsnapshot
    FOR EACH ROW
    WHEN ( new.cvrsnapshotid IS NULL )
BEGIN
    :new.cvrsnapshotid := cvrs_cvrs_id_seq.nextval;
END;
/

CREATE SEQUENCE cwi_cvrwriteinid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER cwi_cvrwriteinid_trg BEFORE
    INSERT ON cvrwritein
    FOR EACH ROW
    WHEN ( new.cvrwriteinid IS NULL )
BEGIN
    :new.cvrwriteinid := cwi_cvrwriteinid_seq.nextval;
END;
/

CREATE SEQUENCE ele_ele_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER ele_ele_id_trg BEFORE
    INSERT ON election
    FOR EACH ROW
    WHEN ( new.electionid IS NULL )
BEGIN
    :new.electionid := ele_ele_id_seq.nextval;
END;
/

CREATE SEQUENCE file_fileid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER file_fileid_trg BEFORE
    INSERT ON "File"
    FOR EACH ROW
    WHEN ( new.fileid IS NULL )
BEGIN
    :new.fileid := file_fileid_seq.nextval;
END;
/

CREATE SEQUENCE gpunit_gpunitid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER gpunit_gpunitid_trg BEFORE
    INSERT ON gpunit
    FOR EACH ROW
    WHEN ( new.gpunitid IS NULL )
BEGIN
    :new.gpunitid := gpunit_gpunitid_seq.nextval;
END;
/

CREATE SEQUENCE imagedata_imagedataid_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER imagedata_imagedataid_trg BEFORE
    INSERT ON imagedata
    FOR EACH ROW
    WHEN ( new.imagedataid IS NULL )
BEGIN
    :new.imagedataid := imagedata_imagedataid_seq.nextval;
END;
/

CREATE SEQUENCE par_par_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER par_par_id_trg BEFORE
    INSERT ON party
    FOR EACH ROW
    WHEN ( new.partyid IS NULL )
BEGIN
    :new.partyid := par_par_id_seq.nextval;
END;
/

CREATE SEQUENCE rd_rd_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER rd_rd_id_trg BEFORE
    INSERT ON reportingdevice
    FOR EACH ROW
    WHEN ( new.reportingdeviceid IS NULL )
BEGIN
    :new.reportingdeviceid := rd_rd_id_seq.nextval;
END;
/

CREATE SEQUENCE sp_sp_id_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER sp_sp_id_trg BEFORE
    INSERT ON selectionposition
    FOR EACH ROW
    WHEN ( new.selectionpositionid IS NULL )
BEGIN
    :new.selectionpositionid := sp_sp_id_seq.nextval;
END;
/
