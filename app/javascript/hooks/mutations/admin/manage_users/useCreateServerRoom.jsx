import { useMutation, useQueryClient } from 'react-query';
import { toast } from 'react-hot-toast';
import { useTranslation } from 'react-i18next';
import axios from '../../../../helpers/Axios';

export default function useCreateServerRoom({ userId, onSettled }) {
  const { t } = useTranslation();
  const queryClient = useQueryClient();

  return useMutation(
    (room) => axios.post('/rooms.json', { room, user_id: userId }),
    {
      onSuccess: () => {
        queryClient.invalidateQueries('getServerRooms');
        toast.success(t('toast.success.room_created'));
      },
      onError: () => { toast.error(t('toast.error.problem_completing_action')); },
      onSettled,
    },
  );
}
