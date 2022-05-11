import React from 'react';
import { useParams } from 'react-router-dom';
import useSharedUsers from '../../hooks/queries/rooms/useSharedUsers';
import SharedAccessList from './SharedAccessList';
import SharedAccessEmpty from './SharedAccessEmpty';
import useRoom from '../../hooks/queries/rooms/useRoom';

export default function SharedAccess() {
  const { friendlyId } = useParams();
  const { isLoading, data: room } = useRoom(friendlyId);
  const { data: users } = useSharedUsers(room.id);

  return (
    (users?.length)
      ? <SharedAccessList users={users} />
      : <SharedAccessEmpty />
  );
}
