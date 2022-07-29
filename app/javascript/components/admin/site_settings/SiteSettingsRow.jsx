import React from 'react';
import PropTypes from 'prop-types';
import { Stack } from 'react-bootstrap';
import useUpdateSiteSetting from '../../../hooks/mutations/admins/site_settings/useUpdateSiteSetting';

export default function SiteSettingsRow({
  name, title, description, value,
}) {
  const updateSiteSetting = useUpdateSiteSetting(name);

  return (
    <Stack direction="horizontal">
      <Stack>
        <strong> {title} </strong>
        {description}
      </Stack>
      <div className="form-switch">
        <input
          className="form-check-input fs-5"
          type="checkbox"
          defaultChecked={value === 'true'}
          onClick={(event) => {
            updateSiteSetting.mutate({ value: event.target.checked });
          }}
        />
      </div>
    </Stack>
  );
}

SiteSettingsRow.propTypes = {
  name: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  value: PropTypes.oneOfType([PropTypes.string, PropTypes.bool]).isRequired,
  description: PropTypes.node.isRequired,
};
