import React from 'react';
import { useParams } from 'react-router-dom';
import useSharedUsers from '../../hooks/queries/shared_accesses/useSharedUsers';
import SharedAccessList from './SharedAccessList';
import SharedAccessEmpty from './SharedAccessEmpty';
import useRoom from '../../hooks/queries/rooms/useRoom';

export default function SharedAccess() {
  const { friendlyId } = useParams();
  const { data: room } = useRoom(friendlyId);
  const { data: users } = useSharedUsers(room.id);

  return (
    (users?.length)
      ? <SharedAccessList users={users} />
      : <SharedAccessEmpty />
  );
}
