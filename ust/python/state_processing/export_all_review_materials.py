
from ust.python.state_processing.control_table_summary import Summary
from ust.python.state_processing.export_template import Template
from ust.python.state_processing.populate_epa_data_tables import Populate
from ust.python.state_processing.qa_check import QualityCheck
from ust.python.util import utils
from ust.python.util.dataset import Dataset
from ust.python.util.logger_factory import logger
from ust.python.util.peer_review import PeerReview


ust_or_release = ''             # Valid values are 'ust' or 'release'
control_id = 0                  # Enter an integer that is the ust_control_id or release_control_id
organization_id = ''            # Optional; if control_id = 0 or None, will find the most recent control_id
exclude_qa = False                # Boolean; defaults to False. Set to True if the QA export has already been created and can be excluded.
refresh_epa_tables = False        # Boolean; defaults to False. Set to True to delete existing data from EPA tables and re-insert from views. 
perform_peer_review = True      # Boolean; defaults to True. Set to False to skip the peer review script. 
qa_include_details = True       # Boolean; defaults to True. Set to False to skip detail worksheets and speed up QA export.
peer_review_export_view_ddl = False  # Boolean; defaults to False. Set to True to export view DDL during peer review.


class ReviewMaterials:
    def __init__(self, 
                 ust_or_release, 
                 control_id=0, 
                 organization_id=None, 
                 exclude_qa=False, 
                 refresh_epa_tables=False,
                 perform_peer_review=True,
                 qa_include_details=True,
                 peer_review_export_view_ddl=False):
        self.ust_or_release = ust_or_release
        self.control_id = control_id
        self.organization_id = organization_id
        if not self.control_id or self.control_id == 0:
            if not self.organization_id:
                logger.warning('Either control_id or organization_id must be passed; exiting...')
                exit()
            self.control_id = utils.get_control_id(self.ust_or_release, self.organization_id)
        self.exclude_qa = exclude_qa
        self.refresh_epa_tables = refresh_epa_tables
        self.perform_peer_review = perform_peer_review 
        self.qa_include_details = qa_include_details
        self.peer_review_export_view_ddl = peer_review_export_view_ddl


    def export_control_summary(self):
        dataset = Dataset(ust_or_release=self.ust_or_release,
                      control_id=self.control_id,
                      base_file_name='control_summary_' + utils.get_timestamp_str() + '.xlsx')
        Summary(dataset=dataset).process()


    def export_qa(self):
        dataset = Dataset(ust_or_release=self.ust_or_release,
                      control_id=self.control_id, 
                      base_file_name='QAQC_' + utils.get_timestamp_str() + '.xlsx')
        QualityCheck(dataset=dataset, include_details=self.qa_include_details).process()



    def export_template(self):
        dataset = Dataset(ust_or_release=self.ust_or_release,
                          control_id=self.control_id, 
                          base_file_name='template_' + utils.get_timestamp_str() + '.xlsx')
        Template(dataset=dataset).process()


    def export_all(self):
        self.export_control_summary()
        if not self.exclude_qa:
            self.export_qa()
        self.export_template()


    def data_refresh(self):
        dataset = Dataset(ust_or_release=self.ust_or_release,
                          control_id=self.control_id, 
                          requires_export=False)
        Populate(dataset, delete_existing=True).execute()


    def peer_review(self):
        dataset = Dataset(ust_or_release=self.ust_or_release,
                       control_id=self.control_id, 
                       base_file_name='peer_review.sql')
        PeerReview(
            dataset=dataset,
            display_bad_data=False,
            overwrite_existing=False,
            export_view_ddl=self.peer_review_export_view_ddl,
        ).process()


    def execute(self):
        if self.refresh_epa_tables:
            self.data_refresh()
        if self.perform_peer_review:
            self.peer_review()        
        self.export_all()



def main(
    ust_or_release,
    control_id=None,
    organization_id=None,
    exclude_qa=False,
    refresh_epa_tables=False,
    perform_peer_review=True,
    qa_include_details=True,
    peer_review_export_view_ddl=False,
):
    review = ReviewMaterials(ust_or_release=ust_or_release, 
                             control_id=control_id, 
                             organization_id=organization_id, 
                             exclude_qa=exclude_qa,
                             refresh_epa_tables=refresh_epa_tables,
                             perform_peer_review=perform_peer_review,
                             qa_include_details=qa_include_details,
                             peer_review_export_view_ddl=peer_review_export_view_ddl)
    review.execute()    


if __name__ == '__main__':   
    main(ust_or_release=ust_or_release,
         control_id=control_id,
         organization_id=organization_id,
         exclude_qa=exclude_qa,
         refresh_epa_tables=refresh_epa_tables,
         perform_peer_review=perform_peer_review,
         qa_include_details=qa_include_details,
         peer_review_export_view_ddl=peer_review_export_view_ddl)
