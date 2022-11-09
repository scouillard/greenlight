import React from 'react';
import { Badge } from 'react-bootstrap';
import PropTypes from 'prop-types';

export default function RoleBadge({ role }) {
  return (
    <Badge className="rounded-pill role-badge ms-2">
      <span className="role-color-dot me-2" ref={(el) => el && el.style.setProperty('background-color', role?.color, 'important')} />
      {role?.name}
    </Badge>
  );
}

RoleBadge.propTypes = {
  role: PropTypes.shape({
    name: PropTypes.string.isRequired,
    color: PropTypes.string.isRequired,
  }).isRequired,
};
